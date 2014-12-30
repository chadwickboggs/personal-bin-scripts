#!/opt/local/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python -O
#
# A RPN calculator for IRC.
# Copyright (C) 2006 MiKael NAVARRO
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

"""IRCNPI
Copyright (C) 2006 MiKael NAVARRO

An unpretentious IRC bot that performs RPN mathematical functions.

0. Create an IRC server (ircd-irc2 on localhost)
1. Launch this Python script & connect to server
2. From IRC client (irssi or erc under Emacs) 
   connect to server & join #ircnpi channel
3. Enter commands like '%ircnpi 1 2 - 4 5 + *'
4. Enter '%ircnpi stop' to stop the bot

"""

# Specific variables for pydoc
__author__ = "MiKael Navarro <klnavarro@gmail.com>"
__date__ = "Wed Dec 21 2011"
__version__ = "0.3.0"
__credits__ = """Thanks to Peyton McCullough for his useful help."""

# Include directives
import sys
import os
import socket

try:
    from npi import main as npi
except ImportError:
    srcdir = os.path.join(os.path.dirname(os.path.realpath(__file__)), "../src")
    sys.path.append(srcdir)  # try to add ../src dir
    from npi import main as npi


#
# Main entry point.
#
def main(options):
    """Connect to an IRC network, become eligible and interact with other users"""

    # Connect to the network
    print("Connecting to %s ..." % options.server)
    irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    irc.connect((options.server, 6667))
    print("Connection to %s established" % socket.gethostbyname_ex(options.server)[0])

    irc.send(b'NICK IRCNPI\r\n')
    irc.send(b'USER IRCNPI IRCNPI IRCNPI :Python IRCNPI\r\n')
    print("Join #ircnpi channel")
    irc.send(b'JOIN #ircnpi\r\n')
    irc.send(b'PRIVMSG #ircnpi :NPI calculator available\r\n')

    # Messages come in a form similar to this:
    #   :Nick!user@host PRIVMSG destination :Message

    while True:
        data = irc.recv(4096).decode()
        if __debug__: print("recv=", data)
        if 'PING' in data:  # respond to PING message from the server
            msg = 'PONG %s\r\n' % (data.split()[1])
            irc.send(msg.encode())
        elif 'PRIVMSG' in data: 
            message = ':'.join(data.split(':')[2:])
            if '%ircnpi' in message:
                nick = data.split('!')[0].replace(':', '')
                destination = ''.join(data.split(':')[:2]).split(' ')[-2]
                command = ' '.join(message.split(' ')[1:])
                if 'stop' in command: break  # stop the bot
                try:
                    print("")
                    result = npi(command + ' q', False)
                    msg = 'PRIVMSG %s :%s: %s\r\n' % (destination, nick, result)
                    if __debug__: print(msg)
                    irc.send(msg.encode())
                except:
                    pass
    
    irc.send(b'PART #ircnpi\r\n')
    irc.send(b'QUIT\r\n')
    irc.close()  # close the connection
    

#
# External entry point.
#
if __name__ == "__main__":
    # Get options
    from optparse import OptionParser, make_option

    option_list = [
        make_option("-s", "--server",
                    action="store", dest="server", 
                    type="string", default="localhost",
                    help="server name or addr (default localhost)"),
        ]

    parser = OptionParser(usage="python -O %prog [options] ... [args] ...", 
                          version=__version__,
                          description="A primitive IRC bot that can connect to a channel (#ircnpi) and act as a calculator.",
                          option_list=option_list)

    (options, args) = parser.parse_args()

    # Compulsory arguments
    if not options.server:
        print("Missing server argument (see --help)!") 
        sys.exit(1)

    # Process start here
    main(options)
