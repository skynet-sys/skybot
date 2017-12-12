# Description
#  天気通報
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
#  HUBOT_WEATHER_API : APIキー
#  HUBOT_WEATHER_ID : 地点ID（1864226は愛媛）
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

config =
	api: process.env.HUBOT_WEATHER_API
	state: process.env.HUBOT_WEATHER_ID
	
module.exports = (robot) ->
  # 投稿時間
  sendTime = "0 0 7 * * 1-7"
  
  # 投稿対象部屋
  #room = "general"
  room = "channelcreationnews"
  
  messageFunc = () ->
	
	request = robot.http("http://api.openweathermap.org/data/2.5/weather?id=#{config.state}&appid=#{config.api}&units=metric").get()
    stMessage = request (err, res, body) ->
      json = JSON.parse body
      weatherName = json['weather'][0]['main']
      icon = json['weather'][0]['icon']
      temp = json['main']['temp']
      temp_max = json['main']['temp_max']
      temp_min = json['main']['temp_min']
      sendMessage = "今日の愛媛の天気は「" + weatherName + "」です。\n気温:"+ temp + "℃ 最高気温："  + temp_max+ "℃ 最低気温：" + temp_min + "℃\nhttp://openweathermap.org/img/w/" + icon + ".png"
      robot.send {room: "#" + room}, sendMessage

  # デバッグ用 myweatherすれば動く
  robot.respond /myweather$/, messageFunc

  # 送信
  new CronJob sendTime, messageFunc, null, true, 'Asia/Tokyo'
