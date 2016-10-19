require 'slack-ruby-client'

TOKEN = ENV["SLACK_TOKEN"]

Slack.configure do |config|
  config.token = TOKEN
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts '...'
end

client.on :message do |data|
  if data['text'].size > 1
    client.message channel:  data['channel'], text:'...'
  end
end

client.start!
