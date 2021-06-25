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
        # メッセージが送信された場合の対応を入力

        # ユーザーからテキスト形式のメッセージが送られて来た場合の対応を入力

          when /.*(明日|あした).*/
            # info[2]：明日の天気
            per06to12 = doc.elements[xpath + 'info[2]/rainfallchance/period[2]'].text
            per12to18 = doc.elements[xpath + 'info[2]/rainfallchance/period[3]'].text
            per18to24 = doc.elements[xpath + 'info[2]/rainfallchance/period[4]'].text
            if per06to12.to_i >= min_per || per12to18.to_i >= min_per || per18to24.to_i >= min_per
              push =
                "テキスト\nテキスト\n降水確率\n　  6〜12時　#{per06to12}％\n　12〜18時　 #{per12to18}％\n　18〜24時　#{per18to24}％\nテキスト"
            else
              push =
                "テキスト"            end
          # テキスト以外（画像等）のメッセージが送られた場合
        else
          push = "テキスト"
        end
        message = {
          type: 'text',
          text: push
        }
        client.reply_message(event['replyToken'], message)
        # LINEお友達追された場合
      when Line::Bot::Event::Follow
        # 登録したユーザーのidをユーザーテーブルに格納
        line_id = event['source']['userId']
        User.create(line_id: line_id)
        # LINEお友達解除された場合
      when Line::Bot::Event::Unfollow
        # お友達解除したユーザーのデータをユーザーテーブルから削除
        line_id = event['source']['userId']
        User.find_by(line_id: line_id).destroy
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


