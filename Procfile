web: (vmstat 1 | tee vmstat.log &) && ps aux && bundle exec ruby groonga/init.rb && ps aux && bundle exec puma -C config/puma.rb && ps aux
