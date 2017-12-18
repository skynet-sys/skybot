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

  # 工数管理
  robot.respond /集計/i, (msg) ->
    today = new Date()
    user = msg.message.user.name
    oldestMilliSec = new Date(today.getFullYear(), today.getMonth(), today.getDate()).getTime() / 1000
    # 当日０時以降の履歴のみ取得する。
    request = msg.http('https://slack.com/api/channels.history')
                  .query(token: #{config.token}, channel: #{config.room}, oldest:oldestMilliSec)
                  .post()

    request (err, res, body) ->
      json = JSON.parse body
      contents = json.messages
                .filter((v) -> v.username == user)
                .filter((z) -> z.text.startsWith("#＿"))
                .reverse()

      if contents.length == 0
         msg.send "作業記録がないですー(~_~メ)"
         return

      formatTime = (seconds) ->
        result = ''
        #時間計算
        hour = Math.floor(seconds / 60 / 60)
        min = Math.floor(seconds / 60 % 60)
        sec = Math.floor(seconds % 60)
        #フォーマット
        if hour > 0
          result += hour + '時'
        if min > 0
          result += min + '分'
        if sec > 0
          result += sec + '秒'
        result

      tasks = contents.map((val,i) ->
        if i == contents.length-1
          obj = {}
          task = val.text.slice(4)
          cost = (Date.now()/ 1000 - val.ts)
          obj[task] = cost
          return obj

        if (i + 1 < contents.length)
          obj = {}
          task = val.text.slice(4)
          cost = (contents[i+1].ts - val.ts)
          obj[task] = cost
          return obj
      )

resultList = []
      hasSameTask = (list,taskName,result) ->
        if list.length == 0
          return false
        for obj in list
          taskInList = Object.keys(obj)[0]
          if taskName == taskInList
            obj[taskInList] += result[taskName]
            return true
        return false

      for result in tasks
        task = Object.keys(result)[0]

        if not hasSameTask(resultList, task, result)
          resultList.push(result)


  # now <test> に反応させる
  # 基本的に作業を切り替えるたびにnowするべき
  robot.hear /^now (.*)/i, (msg) ->
    date = new Date
    text = msg.match[1]
    user = msg.message.user.name

    #tasks = robot.brain.get(key) ? []
    #task = { user: user, date: toYmdDate(date), time: tohhmmTime(date), task: text }
    #tasks.push task
    #robot.brain.set key, tasks
    msg.reply "作業を登録しました #{tohhmmTime(date)} #{text}"

  # task <test> に反応させる
  # 明日のタスクはこっちで入れる
  robot.hear /^task (.*)/i, (msg) ->
    # 発言から内容を取得。date,text,userの3つ
    date = new Date
    text = msg.match[1]
    user = msg.message.user.name

    tasks = robot.brain.get(taskey) ? []
    task = { user: user, date: toYmdDate(date), time: tohhmmTime(date), task: text }
    tasks.push task
    robot.brain.set taskey, tasks
    msg.reply "タスクを登録しました #{tohhmmTime(date)} #{text}"

  # hubot list で一覧を表示する
  robot.respond /list$/, (msg) ->
    date = new Date
    user = msg.message.user.name
    tasks = robot.brain.get(taskey) ? []
    message = tasks.filter (task) ->
      task.date == toYmdDate(date)
    .filter (task) ->
      task.user == user
    .map (task) ->
      "#{task.time} #{task.task}"
    .join '\n'
    msg.reply "#{message}"