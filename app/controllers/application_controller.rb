require 'line/bot'
require 'open-uri'
require 'kconv'
require 'rexml/document'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # before_action :validate_signature

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "914ccff89a9d4bfcbe63085037d268c3"
      config.channel_token = "B89EzCaCXn2cZliuHiC31GNyywxH4GBiwepuVn+AvXbovMFplf7gY96FpaOXCkUqPKYSK+4SbGvgH/xoUnKylG9Hp+HIHI4ZjT8ICnbaZ0m1IIz675m3xbI8pG9N0iDXo/QqsXLH4zhiCvu7jrJLwwdB04t89/1O/w1cDnyilFU="
      # ローカルで動かすだけならベタ打ちでもOK
      # config.channel_secret = "your channel secret"
      # config.channel_token = "your channel token"
    }
  end

end

