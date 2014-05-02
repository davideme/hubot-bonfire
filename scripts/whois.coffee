# Description:
#   Info about users
#
# Configuration:
#   HUBOT_WHOIS_SP - https://spreadsheets.google.com/feeds/list/<key>/<worksheetId>/public/full?sq=nick=davide
#
# Commands:
#   hubot quien es <user> ?

{parseString} = require 'xml2js'


module.exports = (robot) ->

  unless process.env.HUBOT_WHOIS_SP?
    robot.logger.warning 'The HUBOT_WHOIS_SP environment variable not set'

  robot.respond /quien es @?([\w .\-]+)\?*/i, (msg) ->
    nick = msg.match[1].trim()
    msg.send "Espere un momento, por favor ...♬♪"

    sp_url = process.env.HUBOT_WHOIS_SP
    robot.http(sp_url + nick).get() (err, res, body) ->

      if err
        msg.send "Encountered an error :( #{err}"
        return

      if res.statusCode isnt 200
        msg.send "Request didn't come back HTTP 200 :("
        return
      # error checking code here
      parseString body, (err, result) ->
        if result.feed.entry?
          msg.send result.feed.entry[0].content[0]._
        else
          msg.send "There is no information in our database or the NSA one about #{nick}, please add it to https://docs.google.com/spreadsheets/d/1uXa3rfhpw5QHHSSQ19-27o3DoKLiv39_Wq_6BS2ddg8/edit#gid=0"