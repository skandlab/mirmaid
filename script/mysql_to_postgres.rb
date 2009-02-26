#!/usr/bin/env ruby

in_table = false
linenum = 0


while (line = gets)
  line.chomp
    
  #General syntax
  next if line =~ /\/\*.*\*\// #skip comment stuff for mysql
  next if line =~ /^--/ #skip comment stuff for mysql
  next if line =~ /DROP/ # only postgres >= 8.2 can handle "drop if exists"
  next if line =~ /KEY/ # remove key stuff

  #line = line.gsub(/IF\s+EXISTS/,'') # only postgres >= 8.2 can handle "drop if exists"
  line = line.gsub(/ENGINE.*/,'') #no charset lines
  line = line.gsub(/\`/,'') #no `
  line = line.gsub(/auto_increment/,'') #Rails takes care of auto incrementing
  line = line.sub(/^\).*$/,');') #Commit
  line = line.gsub(/FULLTEXT/,"");
  
  #commas
  line = line.gsub(/\,/,""); #We add commas ourselves  
  linenum = linenum + 1

  if (line =~ /create/i)
    in_table = true
    linenum = 0
  end

  if (line =~ /\)\;.*$/)
    in_table = false
  end

  if (in_table and (not line =~ /^\)$/) and (linenum > 1))
    line = ", " + line
  end
    
  #Data types
  # See http://www.htmlite.com/mysql003.php
  # and http://www.postgresql.org/docs/8.1/interactive/datatype.html

  line = line.gsub(/int\(.*\)\s+unsigned/,'integer') #integers
  line = line.gsub(/int\(.*\)/,'integer') #integers
  line = line.gsub(/biginteger/,'bigint') #biginteger
  line = line.gsub(/tinyinteger/,'smallint') #biginteger
  
  line = line.gsub(/tinytext/,'varchar(255)') #tinytext
  line = line.gsub(/mediumtext/,'text') #mediumtext
  line = line.gsub(/longtext/,'text') #longtext 
  
  line = line.gsub(/blob/,'bytea') #blob

  puts line

end
