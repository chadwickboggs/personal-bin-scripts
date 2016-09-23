#!/usr/bin/env fish

set yesterday (date '+%Y-%m-%d' -d 'yesterday')
set today (date '+%Y-%m-%d')

ls *.$yesterday.log | parallel "touch (echo -n {} | sed s/$yesterday/$today/); rmv {}"

