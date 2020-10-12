# Description
#  愛媛FCの試合を取得
# 
# Dependencies:
#  "モジュール名": "モジュールのバージョン" // 依存関係を書いておく
#
# Configuration:
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

cheerio = require 'cheerio-httpcli'
cronJob = require('cron').CronJob

config =
  room: process.env.HUBOT_RANDOM_ROOM
  test: process.env.HUBOT_TEST_ROOM
  match: 'https://soccer.yahoo.co.jp/jleague/teams/detail/30148'

module.exports = (robot) ->
  robot.respond /愛媛FC結果/i, (msg) ->
    matchScore()
  robot.respond /愛媛FC順位/i, (msg) ->
    ranking()

  matchScore = () ->
    cheerio.fetch config.match, (err, $, res) ->
      tdList = []
      res = []
      r = 0
      trCt = 0
      reg = "試合終了ハイライト動画"
      trs = $('.modSoccerScheduleAll table tbody tr').each ->
        trCt++

      tds = $('.modSoccerScheduleAll table tbody td').each ->
        td = $ @
        t = td.text()
        t = t.replace(/\r?\n?\s?/g,"")
        t = t.replace(reg,"")
        tdList.push { t }

      for i in [0..trCt-1]
        h = r + 2
        s = r + 3
        a = r + 4
        st = r + 5
        console.log("rの値:"+r)
        datetime = tdList[r].t
        home = tdList[h].t
        score = tdList[s].t
        away = tdList[a].t
        stadium = tdList[st].t
        res.push { datetime, home, score, away, stadium }
        r = r + 7


      console.log(res)
      mes = res
        .map (c) ->
          "#{c.datetime} #{c.home} #{c.score} #{c.away} #{c.stadium}"
        .join '\n'

      #Slackに投稿
      robot.send {room: "#" + config.room}, "#{mes}"

  ranking = () ->
    cheerio.fetch config.match, (err, $, res) ->
      head = []
      body = []
      trs = $('#modSoccerStanding table thead th').each ->
        trData = $ @
        trText = trData.text()
        console.log("trText:"+trText)
        head.push { trText }

      tds = $('#modSoccerStanding table tbody td').each ->
        tdData = $ @
        tdText = tdData.text()
        console.log("tdText:"+tdText)
        body.push { tdText }

      console.log("head:" + head[0] + " body:" + body[1])
      head.join(" ")
      body.join(" ")

      #Slackに投稿
      robot.send {room: "#" + config.test}, "#{head}\n#{body}"