#!/usr/bin/env fish

set yesterday (date '+%Y-%m-%d' -d 'yesterday')
set today (date '+%Y-%m-%d')
set include_localhost_access_log 0

set USAGE "touch_create_tomcat_logs.fish <options>

\t	Rename tomcat log files, by default from yesterday to today.

\t	Options

\t\t		[-h|--help]\t\t\t	This message gets printed only.
\t\t		[-f|--from] <the from string>\t	The date string to replace in the filenames.  Default: \"$yesterday\"
\t\t		[-t|--to] <the to string>\t	The date string to replace with in the filenames.  Default: \"$today\"
\t\t		[-i|--include]\t\t	Included the \"localhost_access_log.<from date>.txt\" file also.
"

set args (getopt -o "hf:t:i" -l "help,from,to,include" -- $argv)
set args (fish -c "for el in $args; echo \$el; end")
set i 1

while math "$i <= (count $args)"
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
		case "-i"
			set include_localhost_access_log 1
		case "--"
			break
  end
  set i (math "$i + 1")
end

set yesterday (echo -n $yesterday | sed 's/ //')
set today (echo -n $today | sed 's/ //')

ls *.$yesterday.log | parallel "touch (echo -n {} | sed s/$yesterday/$today/); rm -v {}"

if test $include_localhost_access_log -eq 1
	rm -f localhost_access_log.$yesterday.txt
end

echo Touched: (ls *.$today.log)

