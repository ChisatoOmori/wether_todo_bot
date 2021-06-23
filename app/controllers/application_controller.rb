require 'line/bot'
# require 'open-uri'
# require 'kconv'
# require 'rexml/document'

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

  
# # 省略
# when Line::Bot::Event::Message
#   case event.type
#   when Line::Bot::Event::MessageType::Location
# 　　　　　　# LINEの位置情報から緯度経度を取得
#     latitude = event.message['latitude']
#     longitude = event.message['longitude']
#     appId = "606b81c6d6c2c6da34af41ee78d06951"
#     url= "http://api.openweathermap.org/data/2.5/forecast?lon=#{longitude}&lat=#{latitude}&APPID=#{appId}&units=metric&mode=xml"
#    # XMLをパースしていく
#     xml  = open( url ).read.toutf8
#     doc = REXML::Document.new(xml)
#     xpath = 'weatherdata/forecast/time[1]/'
#     nowWearther = doc.elements[xpath + 'symbol'].attributes['name']
#     nowTemp = doc.elements[xpath + 'temperature'].attributes['value']
#     case nowWearther
# 　　　　　# 条件が一致した場合、メッセージを返す処理。絵文字も入れています。
#     when /.*(clear sky|few clouds).*/
#       push = "現在地の天気は晴れです\u{2600}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
#     when /.*(scattered clouds|broken clouds|overcast clouds).*/
#       push = "現在地の天気は曇りです\u{2601}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
#     when /.*(rain|thunderstorm|drizzle).*/
#       push = "現在地の天気は雨です\u{2614}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
#     when /.*(snow).*/
#       push = "現在地の天気は雪です\u{2744}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
#     when /.*(fog|mist|Haze).*/
#       push = "現在地では霧が発生しています\u{1F32B}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
#     else
#       push = "現在地では何かが発生していますが、\nご自身でお確かめください。\u{1F605}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
#     end
# }
# # 省略

end

