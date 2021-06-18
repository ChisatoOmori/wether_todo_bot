require 'line/bot'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :validate_signature

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "067b34857437dea749da9e84cb3fb35b"
      config.channel_token = "OI/bY7BVoXNM5oGzIAjv3ZwrGigx0Vhg0BvpYKJl5nYHj77nHrUsjeKYaOW2zVZ5vsGon82dM0UMsDqF3PJ+lH2LeZyq/Hdo3ZmbZspSlfXwgTN/SMqPu2vq3map57KqwWC8OAJouN+mZpfjhbwt7wdB04t89/1O/w1cDnyilFU="
      # ローカルで動かすだけならベタ打ちでもOK
      # config.channel_secret = "your channel secret"
      # config.channel_token = "your channel token"
    }
  end
end

