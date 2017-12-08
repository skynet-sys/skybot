# Description
#  天気を定時通知する
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
  sendTime = "0 30 7 * * 1-5"
  
  # 投稿対象部屋
  #room = "general"
  room = "channelcreationnews"
  
  # ランダムに投稿するメッセージリスト
  messages = [
    'はーい。本日の愛媛県の天気は',
    'はいはい。お天気通知Botです。\n本日の愛媛県の天気は',
    'はい？天気知りたいですか？\n本日の愛媛県の天気は',
    'はいはーい。お天気Botの本領発揮です。\n本日の愛媛県の天気は'
  ]
  
  request = require 'request'
  qs = require 'querystring'
  
  messageFunc = () ->
	url = "http://api.openweathermap.org/data/2.5/weather?"
        auth = {
            appid: '1111111' # API_KEY
            q:     'Tokyo,jp'                         # 都市
            units: 'metric'                           # 摂氏
        }
        
  	# メッセージをランダムで選択する
  	message = messages[Math.floor(Math.random() * messages.length)]
  	message = "#{ message }"
	
	# 天気・アイコン・現在の気温・最高気温・最低気温
	params = qs.stringify(auth)
        request
            url: url + params
            , (err, response, body) ->
                json = JSON.parse body
                icon = json['weather'][0]['icon']
                temp = json['main']['temp']
                temp_max = json['main']['temp_max']
                temp_min = json['main']['temp_min']
                
		switch json["list"][0]["weather"][0]["main"]
			when "Clear"
			   weatherName = "晴れ"
			when "Clouds"
			   weatherName = "くもり"
			when "Rain"
			   weatherName = "雨"
			when "snow"
			   weatherName = "雪"
			   
                msg.send "#{ message }「" + weatherName + "」です。\n気温:"+ temp + "℃ 最高気温："  + temp_max+ "℃ 最低気温：" + temp_min + "℃\nhttp://openweathermap.org/img/w/" + icon + ".png"

  	robot.send {room: "#" + room}, message

  # デバッグ用 myremindすれば動く
  robot.respond /weather$/, messageFunc 

  # 送信
  new CronJob sendTime, messageFunc, null, true, 'Asia/Tokyo'
