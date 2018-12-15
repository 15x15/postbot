root_path = File.realpath(__dir__)
root_path.slice! 'config'

set :output, "#{root_path}log/cron_log.log"

every 2.hours do # 1.minute 1.day 1.week 1.month 1.year is also supported
  command "ruby #{root_path}run.rb"
end
