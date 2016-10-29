require 'slack-ruby-client'
require './func_google'
require './func_mecab'

TOKEN = ENV["SLACK_TOKEN"]

R18_LIST = File.foreach('wordlist.txt').map do |word|
  word.chomp
end
R18_LIST.freeze

def r18_word? text
  noun_arr  = pickup_noun(text)
  nouns_str = noun_arr.join(' ')
  p nouns_str
  return r18_check_google(nouns_str)
  #R18_LIST.each do |word|
    #if text.include?(word)
    #  return true
    #end
  #end

  #return false
end

#text = 'ぴよぴよ'
#google searchで「ぴよぴよ」を検索
def r18_check_google text
  total_off  = google_search(text, "off")
  total_high = google_search(text, "high")
  
  puts text 
  puts "safe off : #{total_off}"
  puts "safe high: #{total_high}" 

  judge_res = (total_off.to_i - total_high.to_i) > total_high.to_i
  puts judge_res

  return judge_res
end

  


Slack.configure do |config|
  config.token = TOKEN
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts '...'
end

client.on :message do |data|
  if !data['text'][/しよう(。|\.)*/].nil?
    if r18_word?(data['text'])
      sleep(3)
      client.message channel: data['channel'], text: '"そして古見さんは石になった。"'
    else
      client.message channel: data['channel'], text: 'ﾌﾝｽ!'
    end
  else 
    client.message channel: data['channel'], text:'...'
  end
end

client.start!
