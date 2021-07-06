class LinebotController < ApplicationController


  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Location  
          #位置情報が入力された場合
          latitude = event.message['latitude'] #'35.374760'
          longitude = event.message['longitude'] #'132.741469'   
          #経緯度を使った処理
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

        when Line::Bot::Event::MessageType::Text
          #文字列が入力された場合の処理
          case event.message['text']
          when 'スタート'
            # 「スタート」と入力されたときの処理
            message = { type: 'text', text: "start"}
            client.reply_message(event['replyToken'], message)
          when 'ストップ'
            # 「ストップ」と入力されたときの処理
            message = { type: 'text', text: "stop"}
            client.reply_message(event['replyToken'], message)
          when /.*天気.*/
            # 「天気」を含む文字列が入力されたときの処理
            message = {
              type: "template",
              altText: "位置検索中",
              template: {
                  type: "buttons",
                  title: "天気情報",
                  text: "現在の位置を送信しますか？",
                  actions: [
                      {
                        type: "uri",
                        label: "位置を送る",
                        url: "line://nv/location"
                      }
                  ]
              }
            }
          end
          client.reply_message(event['replyToken'], message)

        when Line::Bot::Event::MessageType::Follow
          line_id = event['source']['userId']
          User.create(line_id: line_id)
          message = { type: 'text', text: "フォローありがとう！ 使い方:\n\n・位置情報を送信してください、位置情報が設定されます\nスタートを送ると朝8時に現在の天気が送られます\nストップを送るとストップします"}
          client.reply_message(event['replyToken'], message)

        when Line::Bot::Event::MessageType::Unfollow
          line_id = event['source']['userId']
          User.find_by(line_id: line_id).destroy

        end
        #デフォルトのメッセージ
      message = { type: 'text', text: "デフォルト:使い方:\n\n・位置情報を送信してください\nスタートを送ると朝8時に現在の天気が送られます\nストップを送るとストップします"}
      client.reply_message(event['replyToken'], message)
      end
    }
    "OK"
  end

end
