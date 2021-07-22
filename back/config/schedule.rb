# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron


require File.expand_path(File.dirname(__FILE__) + "/environment")

rails_env = ENV['RAILS_ENV'] || :development
ENV.each { |k, v| env(k, v) }

set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}
set :environment, rails_env

every 1.day do
  runner "Batch::Blob.delete_unattached_blob"
end


# Learn more: http://github.com/javan/whenever
