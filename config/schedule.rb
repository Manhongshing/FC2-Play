require 'open-uri'

# ログの出力
set :output, error: 'log/error.log', standard: 'log/cron.log'
set :environment, :production

# 人気の更新
every 6.hours do
  runner 'History.rank_update'
end

# admin用の集計
every 1.day, at: '0:01 am' do
  runner 'Record.create_yesterday_his'
end

# 検索の更新
every 1.day, at: '6:00 am' do
  runner 'Video.daily_update'
end

every 3.day, at: '2:00 am' do
  runner 'Video.check_available'
end

# 開発中のみ
# every 2.minutes do
#  runner "History.rank_update"
# end
