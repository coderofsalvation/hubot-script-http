hubot-script-http
=================

Simple remote execution of hubot commands using bash,
without the need of an extra rest- or shelladapter.

# Installation

    npm install

# URLS:

    /cmd/help
    /cmd/mustache/me/mark
    and so on

# Commands:

you need to add your ip in order to get access :

    hubot ip show - shows ip addresses which have http GET-access 
    hubot ip add <ip> - adds ip ( '*' allows everybody )
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
    hubot mustache me <query> - Searches Google Images for the specified query 
    hubot mustache me <url> - Adds a mustache to the specified URL.

See? Terminal powa!

NOTE: for a more robust/secure shellscript look <a target="_blank" href="https://gist.github.com/coderofsalvation/b1aaf0a6de5028eb294a" >here</a>

# Why

I made this since I could only find an example which demonstrated
posting something to a room.
This however, gives full access to the hubot commands.
Which is nice, because bash / curl / awk are my daily tools
to work/massage data with.

# Security 

This is a proof of concept, therefore its not totally secure when you are 
not using https + hubot's express authentication (using env variables).
Since not everybody will go thru this labour of setting this up, I've included
 a pseudo ip-security.

Anyways, try adding these express environment vars to get basic auth going:

* EXPRESS_PASSWORD=yourpass
* EXPRESS_USER=admin

# Known issues

* requesting non-existing commands can cause minor hickups on the adapter (since the adapter is temporarely overridden by httprequests).
