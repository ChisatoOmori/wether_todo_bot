class LinebotController < ApplicationController
    require 'line/bot'  # gem 'line-bot-api'
    require 'open-uri'
    require 'kconv'
    require 'rexml/document'
  
    def callback
      body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        return head :bad_request
      end
      events = client.parse_events_from(body)
      events.each { |event|
        case event
            when Line::Bot::Event::Message
              case event.type
              when Line::Bot::Event::MessageType::Text
                message = {
                  type: 'text',
                  text: event.message['text']
                }
                client.reply_message(event['replyToken'], message)
            end
        end
      }
      head :ok
    end
  
    
    private
  
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["914ccff89a9d4bfcbe63085037d268c3"]
        config.channel_token = ENV["B89EzCaCXn2cZliuHiC31GNyywxH4GBiwepuVn+AvXbovMFplf7gY96FpaOXCkUqPKYSK+4SbGvgH/xoUnKylG9Hp+HIHI4ZjT8ICnbaZ0m1IIz675m3xbI8pG9N0iDXo/QqsXLH4zhiCvu7jrJLwwdB04t89/1O/w1cDnyilFU="]
      }
    end
  end
  
  
  