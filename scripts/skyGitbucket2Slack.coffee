# Description
#  テストモジュール
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
#
#
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

module.exports = (robot) ->
  robot.router.post "/gitbucket-to-slack/:room", (req, res) ->
    { room } = req.params
    { body } = req

    try

      if body.payload
        json = JSON.parse body.payload
        message = "==== commit info ====\n"
        message += "timestamp: #{json.commits[0].timestamp}\n"
        message += "id: #{json.commits[0].id}\n"
        message += "author: #{json.commits[0].author.name}<#{json.commits[0].author.email}>\n"
        message += "message: #{json.commits[0].message}\n"
        message += "url: #{json.commits[0].url}\n"

        if message?
            robot.messageRoom room, message
            res.end "OK"
        else
            robot.messageRoom room, "gitbucket integration error."
            res.end "Error"
    catch error
      robot.send
      res.end "Error"