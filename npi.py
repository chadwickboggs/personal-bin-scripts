#!/opt/local/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python
#
# NPI - Calculatrice en Notation Polonaise Inverse. 
# Copyright (C) 2005-2013 MiKael NAVARRO
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

"""NPI - Reverse Polish Notation Calculator.
Copyright (C) 2005-2013 MiKael NAVARRO

An unpretentious RPN calculator.

"""

# Specific variables for pydoc
__author__ = "MiKael Navarro <klnavarro@gmail.com>"
__date__ = "Sun Mar 17 2013"
__version__ = "0.3.2"

# Include directives
import sys
import os
import string
import re

try:
  import readline  # to use with input()
except ImportError as msg:
  print("Warning:", msg)
  
from stack import Stack   # base Stack class
from npi_errors import *  # NPI errors


# Global definitions
_copyright_notice = "Copyright (C) 2005-2013 " + __author__
_version = __version__ + " (" + __date__ + ")"

DONE = True


#
# Display help commands.
#
def npi_help(stack):
  """Display this text."""

  # Sort commands
  cmds = list(_cmd.keys())
  cmds.sort()
  # Display help (list)
  for cmd in cmds:
    print(cmd, _cmd[cmd].__doc__.splitlines()[0], sep="\t")

  return 0


#
# Display commands.
#
def npi_command(stack):
  """Display functions available."""

  printed = 0
  # Sort commands
  cmds = list(_cmd.keys())
  cmds.sort()
  # Display (6 columns)
  for c in [cmds[i:i+6] for i in range(0, len(cmds), 6)]:
    print("\t".join(c))
  
  return 0

#
# Show License.
#
def npi_license(stack):
  """Show CopyLeft license"""

  print("""NPI - Reverse Polish Notation Calculator.\n%s
NPI is distributed in the hope that it will be fun,
but WITHOUT ANY WARRANTY.

NPI is a free software
available under the terms of the GNU Public Licence.
Refer to the file COPYING (which should be included in this distribution)
for the specific terms of this licence.""" % _copyright_notice)

  return 0


#
# Show version.
#
def npi_version(stack):
  """Show NPI version"""

  print("""NPI - Reverse Polish Notation Calculator.\n%s
NPI is distributed in the hope that it will be fun,
but WITHOUT ANY WARRANTY.

Version %s; system: %s
Python: %s""" % (_copyright_notice, _version, sys.platform, sys.version))

  return 0


#
# Quit.
#
def npi_quit(stack):
  """Quit using npi"""
  
  return DONE


#
# Commands this program understand (grammar):
#
_number = "^[-]?\d*[\.]?\d*$"  # number
_integer = "^[-]?\d*[\.]?0*$"  # integer
_float = "^[-]?\d*\.\d*$"  # float
_cmd = {  # cmd (base)
  "help" : npi_help,
  "h" : npi_help,
  "?" : npi_command,
  "g" : npi_license,
  "info" : npi_version,
  "exit" : npi_quit,
  "quit" : npi_quit,
  "q" : npi_quit
  }
# Availables commands modules:
modules = ["cmd_arith",
           "cmd_stack",
           "cmd_const",
           "cmd_trigo",
           "cmd_hyp",
           "cmd_exp",
           "cmd_real",
           "cmd_proba",
           "cmd_rand",
           "cmd_conv",
           "cmd_sr",
           "cmd_loan"]
for module in modules:
  cmd_module = __import__(module)  # import cmd_module
  # Get all operator definitions (npi_*)
  _cmd.update({getattr(cmd_module, cmd).__name__: getattr(cmd_module, cmd)
               for cmd in dir(cmd_module)
               if cmd.startswith("npi_")})

# Auto complete:
candidates = _cmd.keys()
def _completer(word, index):
  matches = [c for c in candidates if c.startswith(word)]
  try:
    return matches[index] + " "
  except IndexError:
    pass
readline.set_completer(_completer)
readline.parse_and_bind("tab: complete")


#
# Usage.
#
def usage(code, msg=""):
  """Usage: python -O npi.py [options] ... [args] ...

A primitive RPN calculator.

Options and arguments:
  -i, --input    use an input script
  -q, --quiet    do not print the welcome message

  -V, --version  show version and exit
  -h, --help     this help

Example:
  python -O npi.py                               (interactive mode)
  echo "2 3 + 4 -" | python -O npi.py --quiet    (send commands via a pipe)
  (echo "2 3 +"; echo "6 -") | python -O npi.py  (send several commands via a pipe)
  python -O npi.py --input "2 3 4 + - q"         (use an input command)
  python -O npi.py --input cmds.txt              (use an input script file)
  python -O npi.py 2 3 4 + - q                   (remaining args used as input command)
  """

  print(usage.__doc__)
  if msg: print("Error:", msg)
  sys.exit(code)


#
# Main entry point.
#
def main(cmd_input="", verbose=True):
  """NPI %s; System: %s\n%s"""

  # Header
  if verbose:
    print(main.__doc__ % (_version, sys.platform, _copyright_notice, ))

  # La Pile !
  stack = Stack()

  # Process:
  done = False;
  while done != DONE:
    # Get inputs
    line = ""
    if cmd_input:
      if os.path.isfile(cmd_input):
        for l in open(cmd_input, 'r').readlines():
          if not l.startswith('#'):
            line = line + " " + l
      else:
        line = cmd_input
      cmd_input = ""  # reset inputs
    else:
      try:
        line = input("> ")
      except EOFError:
        print("eof")
        line = "exit"  # quit

    tokens = line.split()
    #if __debug__: print tokens

    for token in tokens:

      if token in list(_cmd.keys()):  # call the operator
        try:
          done = _cmd[token](stack)
        except Error as e:
          print(e)

      elif re.match(_number, token):  # accumulate operand

        if re.match(_integer, token):
          stack.push(int(float(token)))

        elif re.match(_float, token):
          stack.push(float(token))

      else:
        print("Unknown command '%s' - Try help or ?" % token)

    # Display stack
    stack.aff()

  # Return last result
  if len(stack) >= 1:
    return stack.pop()
  else:
    return None


#
# External entry point.
#
if __name__ == "__main__":
  from optparse import OptionParser, make_option  # need Python 2.3+

  option_list = [
    make_option("-q", "--quiet",
                action="store_false", dest="opt_verbose", 
                default=True,
                help="don't print status messages to stdout"),
    make_option("-i", "--input",
                action="store", dest="cmd_input", 
                type="string", default="",
                help="use an input script (file or command line)"),
    make_option("--usage",
                action="store_true", dest="help_usage", 
                default=False,
                help="display usage examples and exit")
  ]

  parser = OptionParser(usage="python -O %prog [options] ... [args] ...", 
                        version="NPI %s" % _version,
                        description="A primitive RPN calculator.",
                        option_list=option_list)

  (options, args) = parser.parse_args()

  if options.help_usage:
    usage(0)

  # Remaining args (=input command to execute)
  if len(args):
    input_cmd = " ".join(args)
  else:
    input_cmd = options.cmd_input
  
  # Process start here
  main(input_cmd, options.opt_verbose)
