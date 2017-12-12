# Description
#  テストモジュール
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
#  HUBOT_ALARM_MESSAGES:アラームメッセージリスト
#
# Commands:
#  自動
#
# Notes:
#  メモ書き, その他
#
# Author:
#  githubのusernameを書く
#   Remind @channel "テストメッセージです。"

cronJob = require('cron').CronJob

config =
  msg: JSON.parse(process.env.HUBOT_ALARM_MESSAGES ? '[]')

module.exports = (robot) ->
  # 投稿時間
  sendTime = "0 55 17 * * 1-5"
  
  # 投稿対象部屋
  #room = "general"
  room = "channelcreationnews"
  
  # ランダムに投稿するメッセージリスト
  messages = [
    '17時55分です。日報書いて帰りましょう。',
    '17時55分～。日報書こうね。(*´﹃｀*)',
    '17時55分。日報書こうね！',
    'いつもの時間になりました。日報書きましょう(*´･ω･)',
    'まだ日報書いてないの？書いて帰ってね( p_-)',
    '日報書く時間ですよー！！ヽ(*ﾟдﾟ)ノ',
    'どう？捗ってる？日報書く時間ですよー',
    'こんばんは。いつもの時間です。日報書きましょう。'
  ]
  
  messageFunc = () ->

    # メッセージをランダムで選択する
    message = msg[Math.floor(Math.random() * msg.length)]
    message = "@channel #{ message }"

    robot.send {room: "#" + room}, message

  # デバッグ用 myremindすれば動く
  robot.respond /myremind$/, messageFunc

  # 送信
  new cronJob sendTime, messageFunc, null, true, 'Asia/Tokyo'