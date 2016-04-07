require 'net/http'
require 'json'
require 'uri'

class ApiController < ApplicationController
  def callback
    puts json_txt = request.body.read
    json = JSON.parse(request.body.read, {:symbolize_names => true})
    puts results = json[:result]
    results.each do |result|
      event_type = result[:eventType]
      content = result[:content]
      mid = content[:from]
      text = content[:text]
      if event_type == '138311609100106403'
        # add as friend
      else
        # receive message
      end

      uri = URI.parse('https://trialbot-api.line.me/v1/events')
      nhttp = Net::HTTP.new(uri.host, uri.port)
      nhttp.use_ssl = true
      nhttp.verify_mode=OpenSSL::SSL::VERIFY_NONE
      #nhttp.set_debug_output $stderr

      req = Net::HTTP::Post.new(uri.request_uri)
      req.add_field 'Content-Type', 'application/json; charser=UTF-8'
      #req.add_field 'X-Line-ChannelID', '1461843529'
      #req.add_field 'X-Line-ChannelSecret', 'a12b2f8ebf17b88f9810736bf78f7922'
      #req.add_field 'X-Line-Trusted-User-With-ACL', 'uebe8f9b50f45343b74f92e6396db1d2b'
      req.add_field 'X-Line-ChannelID', APP_CONFIG["channel_id"]
      req.add_field 'X-Line-ChannelSecret', APP_CONFIG["channel_secret"]
      req.add_field 'X-Line-Trusted-User-With-ACL', APP_CONFIG["mid"]

      payload = {
        "to" => [mid],
        "toChannel" => 1383378250,
        "eventType" => "138311608800106203",
        "content" => {
          "contentType" => 1,
          "toType" => 1,
          "text" => "Hello, Jose!"
        }
      }.to_json
      puts req.body = payload

      res = nhttp.start {|http|
        http.request(req)
      }
      puts res.body
    end
    render :text => "hello"
  end
end
