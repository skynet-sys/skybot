# Description:
#   Remind @channel "17時55分になりました。日報を書いて帰りましょう。"

cronJob = require('cron').CronJob

module.exports = (robot) ->
  cronJob = new cronJob('00 35 18 * * 1-5', () ->
    envelope = room: "#general"
    robot.sen envelope, "17時55分になりました。日報を書いて帰りましょう。"
  )
  
  
  cronJob.start() # cronJobの実行