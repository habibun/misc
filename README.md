# Miscellaneous

## Command

### Size   
`df -h` # hard drive free space   
`du -hs /path` # size of a directory   
`du -hs /path/*` # size of a all directory inside   
`du -hs /path/* | sort -rh` # size of a all directory inside and sort by size desc  

### Terminal
`command & disown` # cmd should be started in an independent terminal  

### File  
`truncate -s 0 file` # empty log files  

### Xdebug
`sudo phpdismod xdebug` # disable xdebug  
`sudo phpenmod xdebug` # enable xdebug  
