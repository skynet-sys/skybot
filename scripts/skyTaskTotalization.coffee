# Description
#  タスクの集計
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
#  HUBOT_SLACK_TOKEN :Slackトークン
#  HUBOT_TEST_ROOM :テスト投稿用
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

config =
  token: process.env.HUBOT_SLACK_TOKEN
  room: process.env.HUBOT_TEST_ROOM

dateformat = require('dateformat')
Q = require('q')
Slack = require('slack-node')
 
to_unixtime = (time) -> Math.floor(time.getTime()/1000)
 
module.exports = (robot) ->
  slack = new Slack(config.token)
  weekdays = [ "日", "月", "火", "水", "木", "金", "土" ]
 
  countEmoji = ->
    today = new Date()
    yesterday = new Date(new Date(today.toString()).setDate(today.getDate() - 1))
    # 月曜なら金曜日をみる
    if today.getDay() is 1
      yesterday = new Date(new Date(today.toString()).setDate(today.getDate() - 3)) 
    date = dateformat(yesterday, 'yyyymmdd')
    date_str = "#{dateformat(yesterday, 'yyyy/mm/dd')}(#{weekdays[yesterday.getDay()]})"
    yesterday_begin = new Date(dateformat(yesterday, 'yyyy/mm/dd') + " 00:00:00")
    yesterday_end = new Date(dateformat(yesterday, 'yyyy/mm/dd') + " 23:59:59")
    api = Q.denodeify slack.api
    apis_by_channel = []
    apis_by_channel_options = []
    result = {}

    api("channels.list").then (response) ->
      for c in response.channels
        option = {channel: c.id, latest: to_unixtime(yesterday_end), oldest: to_unixtime(yesterday_begin), count: 1000}
        apis_by_channel_options.push(option)
        apis_by_channel.push(api("channels.history", option))
      return Q.all(apis_by_channel)
    .then (values) ->
      for i in [0..(values.length-1)]
        reactions_get_qs = []
        v = values[i]
        for m in v.messages
          reactions = m.reactions
          reactions = m.file.reactions if m.file?.reactions
          if reactions
            user = robot.adapter.client.rtm.dataStore.getUserById(m.user)?.name
            result[user] = {} unless result[user]
            for r in reactions
              result[user][r.name] = 0 unless result[user][r.name]
              result[user][r.name] += r.count
      results_str = "#{date_str}の集計結果です。\r\n"
      for name, r of result
        results_str += "#{name}: \t"
        for emoji, count of r
          results_str += ":#{emoji}:: #{result[name][emoji]}, "
        results_str += "\r\n"
      robot.send {room: "#" + config.room}, results_str
    .catch (err) ->
      robot.logger.error(err)
      robot.send {room: "#" + config.room}, '集計中にエラーがおきました'

  # デバッグ用 mytestすれば動く
  robot.respond /mytest$/, countEmoji