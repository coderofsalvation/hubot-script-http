hubot-script-http
=================

Simple remote execution of hubot commands using bash,
without the need of an extra rest- or shelladapter.

# Installation

    npm install

# URLS:

    /hubot/cmd/help
    /hubot/cmd/mustache/me/mark
    and so on

# Commands:

you need to add your ip in order to get access :

    hubot ip show - shows ip addresses which have http GET-access to /hubot/cmd[/yourcommand]
    hubot ip add <ip> - adds ip
    hubot ip flush - clears the ip table

# Terminal powa!

Just put this little shellscript somewhere ('hubotbash' e.g.)

    #!/bin/bash 
    PORT=5555
    URL="http://localhost:$PORT/cmd/$*"
    URL="${URL// //}"
    curl "$URL"
    
Then do this:

    $ hubotbash help | grep mustache
    hubot mustache me <query> - Searches Google Images for the specified query and mustaches it.
    hubot mustache me <url> - Adds a mustache to the specified URL.

See? Terminal powa!

# Why

I made this since I could only find an example which demonstrated
posting something to a room.
This however, gives full access to the hubot commands.
Which is nice, because bash / curl / awk are my daily tools
to work/massage data with.

# Security 

This is a proof of concept, therefore its not totally secure.
The pseudo ip-security is probably fine for intranets but you probably want to 
add https-auth in case of sensitive-data-over-the-web (which was not my case)

# Todo 

Maybe in the future I/somebody will add hooks to the 'enterroom' and 'leaveroom'-events.
When somebody enters the room, his ip will be added..and remove upon leaving.
