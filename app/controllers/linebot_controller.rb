class LinebotController < ApplicationController


  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Location  
          latitude = event.message['latitude'] #'35.374760'
          longitude = event.message['longitude'] #'132.741469'   
          appId = "606b81c6d6c2c6da34af41ee78d06951"
          url= "http://api.openweathermap.org/data/2.5/forecast?lon=#{longitude}&lat=#{latitude}&APPID=#{appId}&units=metric&mode=xml"
         # XMLをパースしていく
          xml  = open( url ).read.toutf8
          doc = REXML::Document.new(xml)
          xpath = 'weatherdata/forecast/time[1]/'
          nowWearther = (doc.elements[xpath + 'symbol'].attributes['name']).to_s
          nowTemp = doc.elements[xpath + 'temperature'].attributes['value']
          case nowWearther
          # 条件が一致した場合、メッセージを返す処理。絵文字も入れています。
          when "clear sky", "few clouds"
            push = "現在地の天気は晴れです\u{2600}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
          when "scattered clouds", "broken clouds", "overcast clouds"
            push = "現在地の天気は曇りです\u{2601}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
          when "rain", "thunderstorm", "drizzle"
            push = "現在地の天気は雨です\u{2614}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
          when "snow"
            push = "現在地の天気は雪です\u{2744}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
          when "fog", "mist", "Haze"
            push = "現在地では霧が発生しています\u{1F32B}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
          else
            push = "現在地では何かが発生していますが、\nご自身でお確かめください。\u{1F605}\n\n現在の気温は#{nowTemp}℃です\u{1F321}"
          end
      
      
          message = {
            type: 'text',
            text: push #event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    "OK"
  end

# 省略
# when Line::Bot::Event::Message
#   case event.type
#   when Line::Bot::Event::MessageType::Location
# # LINEの位置情報から緯度経度を取得

# 省略

end
