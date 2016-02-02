class Admin::AuthorsController < Admin::ApplicationController
  def index
    @authors = authors
  end

  def show
    @author = authors.find(params[:id])
  end

  def new
    @author = authors.build
  end

  def create
    @author = authors.build(author_params)

    if @author.save
      redirect_to [:admin, @author], notice: '著者情報が作成されました'
    else
      render :new
    end
  end

  def edit
    @author = authors.find(params[:id])
  end

  def update
    @author = authors.find(params[:id])

    if @author.update(author_params)
      redirect_to [:admin, @author], notice: '著者情報が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @author = authors.find(params[:id])

    @author.destroy

    redirect_to admin_authors_path, notice: '著者情報が削除されました'
  end

  private

  def authors
    current_site.authors
  end

  def author_params
    params.require(:author).permit(
      :name,
      :responsibility,
      :title,
      :affiliation,
      :photo
    )
  end
end
