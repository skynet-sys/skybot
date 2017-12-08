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

cron = require('cron').CronJob

module.exports = (robot) ->
  new cron '0 28 19 * * 1-5', () =>
    robot.send {room: "#general"}, "テストメッセージです。"
   , null, true, "Asia/Tokyo"
