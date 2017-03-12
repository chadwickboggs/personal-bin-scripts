#!/usr/bin/env fish

set yesterday (date '+%Y-%m-%d' -d 'yesterday')
set today (date '+%Y-%m-%d')

set USAGE "touch_create_tomcat_logs.fish <options>

\t	Rename tomcat log files, by default from yesterday to today.

\t	Options

\t\t		[-h|--help]\t\t\t	This message gets printed only.
\t\t		[-f|--from] <the from string>\t	The date string to replace in the filenames.  Default: \"$yesterday\"
\t\t		[-t|--to] <the to string>\t	The date string to replace with in the filenames.  Default: \"$today\"
"

set args (getopt -o "hf:t:" -l "help,from,to" -- "$argv")
set args (fish -c "for el in $args; echo \$el; end")
set i 1
while true
  switch "$args[$i]"
		case "-h"
			echo -e $USAGE; exit
		case "--help"
			echo -e $USAGE; exit
		case "-f"
			set i (math "$i + 1")
			set yesterday "$args[$i]"
		case "--from"
			set i (math "$i + 1")
			set yesterday "$args[$i]"
		case "-t"
			set i (math "$i + 1")
			set today "$args[$i]"
		case "--to"
			set i (math "$i + 1")
			set today "$args[$i]"
		case "--"
			break
  end
  set i (math "$i + 1")
end

set yesterday (echo -n $yesterday | sed 's/ //')
set today (echo -n $today | sed 's/ //')

ls *.$yesterday.log | parallel "touch (echo -n {} | sed s/$yesterday/$today/); rm -v {}"

echo Touched: (ls *.$today.log)

