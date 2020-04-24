# Description
#   発言をひらがな、カタカナに変換します
#
# Configuration:
#   GOOLAB_APP_ID - GooラボのアプリケーションIDを設定
#
# Commands:
#   hubot hiragana <string> - 発言をひらがなに変換
#   hubot katakana <string> - 発言をカタカナに変換
#

baseUrl = "https://labs.goo.ne.jp/api/hiragana"

APP_ID = process.env.GOOLAB_APP_ID
if !APP_ID
  console.error "ERROR: You should set your GOOLAB_APP_ID env variables."

module.exports = (robot) ->
  robot.respond /(hiragana|katakana) (.*)/i, (msg) ->
    data = JSON.stringify {
        "app_id": APP_ID
        "sentence": msg.match[2]
        "output_type": msg.match[1]
    }

    robot.http(baseUrl)
      .header("Content-type", "application/json")
      .post(data) (err, res, body) ->
        try
          result = JSON.parse(body)
          msg.send result.converted
        catch err
          robot.logger.err("#{err}")