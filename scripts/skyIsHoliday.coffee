# Description
#  テストモジュール
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
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

config =
  room: process.env.HUBOT_ALARM_ROOM

module.exports = (robot) ->
  robot.respond /休み/i, (msg) ->
    isHoliday(msg)

  isHoliday = (msg) ->
    today = new Date();
    if checkIsNotHoliday(today)
      #メッセージを送信する
      msg.reply "今日は休みじゃないよ！"
    else
      msg.reply "今日は休み！"

#休日でない場合にtrueを返す
checkIsNotHoliday = (date) ->
  holiday = japaneseHolidays.isHoliday(date)
  console.log(holiday)
  unless holiday?
    return true
  return false