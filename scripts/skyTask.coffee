# Description
#  タスク管理
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
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

  # hubot now <test> に反応させる
  robot.hear /^now (.*)/i, (msg) ->
    # 発言から内容を取得。date,text,userの3つ
    date = new Date
    text = msg.match[1]
    user = msg.message.user.name

    tasks = robot.brain.get(key) ? []
    task = { user: user, date: toYmdDate(date), time: tohhmmTime(date), task: text }
    tasks.push task
    robot.brain.set key, tasks
    msg.reply "task saved! #{tohhmmTime(date)} #{text}"

  robot.respond /today$/, (msg) ->
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