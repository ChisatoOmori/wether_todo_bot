class LinebotController < ApplicationController
    
  require 'line/bot'
  require 'open-uri'
  require 'kconv'
  require 'rexml/document'
  
# 省略
when Line::Bot::Event::Message
    case event.type
    when Line::Bot::Event::MessageType::Location
　　　　　　# LINEの位置情報から緯度経度を取得
      latitude = event.message['latitude']
      longitude = event.message['longitude']
      appId = "取得したAPI KEY"
      url= "http://api.openweathermap.org/data/2.5/forecast?lon=#{longitude}&lat=#{latitude}&APPID=#{appId}&units=metric&mode=xml"
     # XMLをパースしていく
      xml  = open( url ).read.toutf8
      doc = REXML::Document.new(xml)
      xpath = 'weatherdata/forecast/time[1]/'
      nowWearther = doc.elements[xpath + 'symbol'].attributes['name']
      nowTemp = doc.elements[xpath + 'temperature'].attributes['value']
      case nowWearther
　　　　　# 条件が一致した場合、メッセージを返す処理。絵文字も入れています。
      when /.*(clear sky|few clouds).*/
        push = "現在地の天気は晴れです\u{2600}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
      when /.*(scattered clouds|broken clouds|overcast clouds).*/
        push = "現在地の天気は曇りです\u{2601}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
      when /.*(rain|thunderstorm|drizzle).*/
        push = "現在地の天気は雨です\u{2614}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
      when /.*(snow).*/
        push = "現在地の天気は雪です\u{2744}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
      when /.*(fog|mist|Haze).*/
        push = "現在地では霧が発生しています\u{1F32B}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
      else
        push = "現在地では何かが発生していますが、\nご自身でお確かめください。\u{1F605}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
      end
  }
# 省略
end
