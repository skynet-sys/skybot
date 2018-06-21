# Description
#  テストモジュール
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
#  HUBOT_ALARM_MESSAGES:アラームメッセージリスト
#  HUBOT_ALARM_SUB_MESSAGES:アラームメッセージリスト
#  HUBOT_ALARM_URL:アラームしたいURL
#  HUBOT_ALARM_ROOM:アラーム投稿先
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

japaneseHolidays = require('japanese-holidays')
cronJob = require('cron').CronJob

config =
  msg: JSON.parse(process.env.HUBOT_ALARM_MESSAGES ? '[]')
  msg2: JSON.parse(process.env.HUBOT_ALARM_SUB_MESSAGES ? '[]')
  msgUrl: JSON.parse(process.env.HUBOT_ALARM_URL ? '[]')
  room: process.env.HUBOT_ALARM_ROOM

module.exports = (robot) ->
  # 投稿時間
  sendTime = "0 55 17 * * 1-5"

  messageFunc = () ->

    today = new Date();
    if checkIsNotHoliday(today)
      # メッセージをランダムで選択する
      message = config.msg[Math.floor(Math.random() * config.msg.length)]
      message2 = config.msg2[Math.floor(Math.random() * config.msg2.length)]
      messageUrl = config.msgUrl[Math.floor(Math.random() * config.msgUrl.length)]
      message = "@channel #{ message } \n #{ message2 } \n #{ messageUrl }"

      #メッセージを送信する
      robot.send {room: "#" + config.room }, message

  # 送信
  new cronJob sendTime, messageFunc, null, true, 'Asia/Tokyo'

#休日でない場合にtrueを返す
checkIsNotHoliday = (date) ->
  holiday = japaneseHolidays.isHoliday(date)
  console.log("Debug Test")
  console.log(holiday)
  unless holiday?
    return true
  return false