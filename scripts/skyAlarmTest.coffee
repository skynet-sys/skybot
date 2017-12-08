# Description
#  テストモジュール
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
#  環境設定を書く
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

CronJob = require('cron').CronJob

module.exports = (robot) ->
  # 投稿時間
  sendTime = "0 55 17 * * 1-5"
  
  # 投稿対象部屋
  #room = "general"
  room = "channelcreationnews"
  
  # ランダムに投稿するメッセージリスト
  messages = {
    '17時55分です。日報書いて帰りましょう。',
    '17時55分～。日報書こうね。(*´﹃｀*)',
    '17時55分。日報書こうね！',
    'いつもの時間になりました。日報書きましょう(*´･ω･)',
    'まだ日報書いてないの？書いて帰ってね( p_-)',
    '日報書く時間ですよー！！ヽ(*ﾟдﾟ)ノ',
    'どう？捗ってる？日報書く時間ですよー',
    'こんばんは。いつもの時間です。日報書きましょう。'
  }
  
  messageFunc = () ->

  	# メッセージをランダムで選択する
  	message = messages[Math.floor(Math.random() * messages.length)]

  	message = "@channel #{ message }"
  	
  	robot.send {room: "#" + room}, message

  # デバッグ用 myremindすれば動く
  robot.respond /myremind$/, messageFunc

  # 送信
  new CronJob sendTime, messageFunc, null, true, 'Asia/Tokyo'
