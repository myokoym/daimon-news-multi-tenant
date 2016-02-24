# Usage:
#   bin/rails r scripts/import_wp_post.rb <file or uri> <FQDN>
#

require "open-uri"

path_or_uri, fqdn = ARGV

rows = []
open(path_or_uri, "r") do |file|
  header_line = file.gets.chomp
  headers = header_line.split("\t")
  file.each_line do |line|
    row = {}
    line.chomp
    fields = line.split("\t")
    headers.zip(fields).each do |key, value|
      row[key] = value
    end
    next if row["post_content"].blank?
    next unless /\Apublish|future\z/ =~ row["post_status"]
    rows << row
  end
end

max_id = Post.maximum(:id)
if max_id
  ActiveRecord::Base.connection.execute("SELECT setval('posts_id_seq', #{max_id+1});")
else
  puts "max_id is nil"
end

class LitePost < ActiveRecord::Base
  self.table_name = :posts

  belongs_to :site
  belongs_to :category
  belongs_to :author

  validates :body, presence: true
  validates :thumbnail, presence: true

  before_save :assign_public_id

  def assign_public_id
    self.public_id ||= (self.class.maximum(:public_id) || 0) + 1
  end
end

Site.class_eval do
  has_many :lite_posts
end

site = Site.find_or_create_by!(fqdn: fqdn) do |s|
  s.name = fqdn
end

category = nil

site.transaction do
  category = site.categories.find_or_create_by!(name: "uncategorized") do |c|
    c.description = "uncategolized posts"
    c.slug = "uncategorized"
    c.order = 0
  end
end

puts "Total: #{rows.size}"

def save_rows!(site, category, rows)
  posts = []
  rows.each do |row|
    post = site.lite_posts.find_or_initialize_by(public_id: row["ID"])
    post.assign_attributes(title: row["post_title"],
                           published_at: row["post_date_gmt"],
                           body: row["post_content"],
                           category: category,
                           thumbnail: "dummy",
                           original_updated_at: row["post_modified_gmt"],
                           original_source: row["post_content"],
                           updated_at: row["post_modified_gmt"])
    posts << post if post.new_record?
  end
  unless posts.empty?
    puts "Importing #{posts.size} rows"
    LitePost.import(posts)
  end
end

rows.each_slice(500) do |_rows|
  site.transaction do
    save_rows!(site, category, _rows)
  end
end

puts "done: #{site.lite_posts.count} records exist."