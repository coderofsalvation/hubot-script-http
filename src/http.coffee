# Description:
#
#   Simple remote execution of hubot commands using bash,
#   without the need of an extra rest- or shelladapter.
#
#   This is a proof of concept is totally unsecure (i.e. don't use this in production)
#   The pseudo ip-security is probably fine for intranets but you probably want to 
#   add https-auth in case of sensitive-data-over-the-web (which was not my case)
#
#   Maybe in the future I/sombody will add hooks to the 'enterroom' and 'leaveroom'-events.
#   When somebody enters the room, his ip will be added..and remove upon leaving.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ip show - shows ip addresses which have http GET-access to /hubot/cmd[/yourcommand]
#   hubot ip add <ip> - adds ip
#   hubot ip flush - clears the ip table
#
# URLS:
#   /hubot/cmd/help
#   /hubot/cmd/mustache/me/mark
# and so on

spawn = require('child_process').spawn
{TextMessage} = require '../../hubot/src/message'

module.exports = (robot) ->

  robot.brain.data.ip ?= []
  
  robot.respond /ip flush$/i, (msg) ->
    robot.brain.data.ip = []
    msg.send "flushed"
  
  robot.respond /ip show$/i, (msg) ->
    msg.send robot.brain.data.ip

  robot.respond /ip add (.*)$/i, (msg) ->
    ip = msg.match[1].trim()
    robot.brain.data.ip.push ip
    msg.send "enabled access for ip "+ip

  robot.router.get "/cmd*", (req,res) ->
    ip = req.headers['x-forwarded-for'] or req.connection.remoteAddress or req.socket.remoteAddress or req.connection.socket.remoteAddress;
    if ip not in robot.brain.data.ip then return res.end "access denied"
    args = req.url.split "/"
    args = args.filter (i) -> i isnt "cmd" and i isnt ""
    args = args.join " "
    robot._send ?= robot.adapter.send;
    robot.adapter.send = (user,strings...) ->
      res.end strings.toString() if user.user.name is "http"
      robot.adapter.send = robot._send if user.user.name isnt "http"
    user = robot.brain.userForId '1', name: 'http', room: 'http'
    robot.receive new TextMessage user, robot.name+" "+args, 'messageId'

