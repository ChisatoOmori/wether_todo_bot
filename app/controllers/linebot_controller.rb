class LinebotController < ApplicationController
    require 'line/bot'  # gem 'line-bot-api'
  
    # callbackアクションのCSRFトークン認証を無効
    protect_from_forgery :except => [:callback]
  
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = "067b34857437dea749da9e84cb3fb35b"
        config.channel_token = "OI/bY7BVoXNM5oGzIAjv3ZwrGigx0Vhg0BvpYKJl5nYHj77nHrUsjeKYaOW2zVZ5vsGon82dM0UMsDqF3PJ+lH2LeZyq/Hdo3ZmbZspSlfXwgTN/SMqPu2vq3map57KqwWC8OAJouN+mZpfjhbwt7wdB04t89/1O/w1cDnyilFU="
      }
    end
  
    def callback
      body = request.body.read
  
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        head :bad_request
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
          end
        end
      }
  
      head :ok
    end
  end
  