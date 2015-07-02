env :PATH, ENV['PATH']
set :output, 'log/crontab.log'
set :enviroment, :production
set :job_template, "/bin/zsh -l -c ':job'"

# 毎日5:00にDBのバックアップを取る
every 1.day, at: '5:00 am' do
  rake 'db:data:dump_backup RAILS_ENV=production'
end

# 毎日4:30にDBのバックアップを取る
every 1.day, at: '4:30 am' do
  rake 'textage:update RAILS_ENV=production'
end
