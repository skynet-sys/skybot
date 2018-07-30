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
  room: process.env.HUBOT_TEST_ROOM
  match: 'https://www.jleague.jp/club/ehime/day/#day'

TRM = -15
# TRM の-1個のスペースを設定
TRM_SPACE = "              "

module.exports = (robot) ->
  robot.respond /test/i, (msg) ->
    matchScore()

  matchScore = () ->
    cheerio.fetch config.match, (err, $, res) ->
      # 更新日時
      updated = "#{$('.upDate').text()}"
      #now = new Date()
      #today = now.getFullYear()+"年"+( "0"+( now.getMonth()+1 ) ).slice(-2)+"月"+( "0"+now.getDate() ).slice(-2)+"日"+( "0"+now.getHours() ).slice(-2)+"時"+( "0"+(now.getMinutes()-1) ).slice(-2)
      #now.setHours(now.getHours()-USA)

      #今後3試合の予定
      #data = '*' + $('.dataTable table caption').text() + '*\n'

      # テーブルヘッダを取得
      header = ""
      $('.todayResult table tr th').each ->
      header = header + (TRM_SPACE + $(this).text()).substr(TRM)
      header = header.replace("合計", "")
      header = header.slice(0, -40)
      data = data + header.slice(4)
      # テーブルのセル取得
      $('.todayResult table tr').each ->
      data = data + (TRM_SPACE).substr(TRM)
      value = ""
      $('td', $(this)).each ->
      value = value + (TRM_SPACE + $(this).text()).substr(TRM)
      data = data + value.slice(4)
      data = data + '\n'
      robot.send {room: "#" + config.room}, "#{data}"