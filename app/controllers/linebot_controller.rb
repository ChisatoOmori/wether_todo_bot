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
          nowWearther_id = (doc.elements[xpath + 'symbol'].attributes['number']).to_i
          nowTemp = doc.elements[xpath + 'temperature'].attributes['value']
          nowHumi = doc.elements[xpath + 'humidity'].attributes['value']

          case nowWearther_id
          # 条件が一致した場合、メッセージを返す処理。絵文字も入れています。
          when 800
            push2 = "現在地の天気は晴れです\u{2600}\n\n現在の気温は#{nowTemp}℃です\u{1F321}\n\n現在の湿度は#{nowHumi}%です"
          when 801..804
            push2 = "現在地の天気は曇りです\u{2601}\n\n現在の気温は#{nowTemp}℃です\u{1F321}\n\n現在の湿度は#{nowHumi}%です"
          when 500..599
            push2 = "現在地の天気は雨です\u{2614}\n\n現在の気温は#{nowTemp}℃です\u{1F321}\n\n現在の湿度は#{nowHumi}%です"
          when 600..699
            push2 = "現在地の天気は雪です\u{2744}\n\n現在の気温は#{nowTemp}℃です\u{1F321}\n\n現在の湿度は#{nowHumi}%です"
          when 300..399
            push2 = "現在地では霧が発生しています\u{1F32B}\n\n現在の気温は#{nowTemp}℃です\u{1F321}\n\n現在の湿度は#{nowHumi}%です"
          else
            push2 = "現在地では何かが発生していますが、\nご自身でお確かめください。\u{1F605}\n\n現在の気温は#{nowTemp}℃です\u{1F321}\n\n現在の湿度は#{nowHumi}%です"
          end
          p nowWearther
          p nowTemp
          p nowWearther_id
          p nowHumi

          message = {
            type: 'text',
            text: push2
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video, Line::Bot::Event::MessageType::Text
          line = line_id.all
          line.each do |line|
            message = { 
              "type": "text",
              "text": "line"
            }
            client.reply_message(event['replyToken'], message)
            end
          message = {
            "type": "template",
            "altText": "位置検索中",
            "template": {
                "type": "buttons",
                "title": "現在の天気",
                "text": "現在の位置を送信しますか？",
                "actions": [
                    {
                      "type": "uri",
                      "label": "位置を送る",
                      "uri": "line://nv/location"
                    }
                ]
            }
          }
          client.reply_message(event['replyToken'], message)
        end
        when Line::Bot::Event::Follow
          line_id = event['source']['userId']
          User.create(line_id: line_id)
        when Line::Bot::Event::Unfollow
          line_id = event['source']['userId']
          User.find_by(line_id: line_id).destroy
        end
    }
    "OK"
  end

end
