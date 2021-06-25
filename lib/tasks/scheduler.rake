task :update_feed => :environment do
    require 'line/bot'  # gem 'line-bot-api'
    require 'open-uri'
    require 'kconv'
    require 'rexml/document'
  #line-bot側の設定
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    # 使用したいxmlデータURLを入力
    # xmlデータをパース
    # パスの共通部分を変数化
    # 6時〜12時の降水確率
    # メッセージを発信する降水確率の下限値の設定
    min_per = 20
    if per06to12.to_i >= min_per || per12to18.to_i >= min_per || per18to24.to_i >= min_per
      word1 =
        ["テキスト入力",].sample
      word2 =
        ["テキスト入力"].sample
      # 降水確率によってメッセージを変更する閾値の設定。
  #ifの条件式の中で降水確率によって送信されるメッセージを変更
      mid_per = 50
      if per06to12.to_i >= mid_per || per12to18.to_i >= mid_per || per18to24.to_i >= mid_per
        word3 = "テキスト入力"
      else
        word3 = "テキスト入力！"
      end
      # 発信するメッセージの設定
      push =
        "#{word1}\n#{word3}\n降水確率\n　  6〜12時　#{per06to12}％\n　12〜18時　 #{per12to18}％\n　18〜24時　#{per18to24}％\n#{word2}"
      # メッセージの発信先idを配列で渡す必要があるため、userテーブルよりpluck関数を使ってidを配列で取得。
  #multicastsメソッドは、今回利用しているgem「line-bot-api」で定義されており、このメソッドを呼び出している
      user_ids = User.all.pluck(:line_id)
      message = {
        type: 'text',
        text: push
      }
      response = client.multicast(user_ids, message)
    end
    "OK"
  end