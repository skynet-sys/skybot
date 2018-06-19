# Description
#  タスク管理
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

# 時刻を受け取ってYYYY-mm-dd形式で返す
toYmdDate = (date) ->
  Y = date.getFullYear()
  m = ('0' + (date.getMonth() + 1)).slice(-2)
  d = ('0' + date.getDate()).slice(-2)
  return "#{Y}-#{m}-#{d}"

# 時刻を受け取ってhh:mm形式で返す
tohhmmTime = (date) ->
  hh = ('0' + date.getHours()).slice(-2)
  mm = ('0' + date.getMinutes()).slice(-2)
  return "#{hh}:#{mm}"

module.exports = (robot) ->
  # keyを設定
  key = "timeTracker"
  taskey = "taskTracker"

  # now <test> に反応させる
  # 基本的に作業を切り替えるたびにnowするべき
  robot.hear /^now (.*)/i, (msg) ->
    date = new Date
    text = msg.match[1]
    user = msg.message.user.name

    tasks = robot.brain.get(key) ? []
    task = { user: user, date: toYmdDate(date), time: tohhmmTime(date), task: text }
    tasks.push task
    robot.brain.set key, tasks
    msg.reply "作業を登録しました #{tohhmmTime(date)} #{text}"

  # hubot list で一覧を表示する
  robot.respond /list$/, (msg) ->
    date = new Date
    user = msg.message.user.name
    tasks = robot.brain.get(key) ? []
    message = tasks.filter (task) ->
      task.date == toYmdDate(date)
    .filter (task) ->
      task.user == user
    .map (task) ->
      "#{task.time} #{task.task}"
    .join '\n'
    msg.reply "#{message}"