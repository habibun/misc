## About The Project
Miscellaneous  

## Context

### [Nginx](nginx)
### [Template](template)
### [Script](script)
### [Phpstorm](phpstorm)
### [Makefile](makefile)
### [Terminal](terminal)

--- 
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
`unrar x -r file.rar` # unpack files

### Xdebug
`sudo phpdismod xdebug` # disable xdebug  
`sudo phpenmod xdebug` # enable xdebug  

### Search
```bash
# Search a File by Name
find -name <file_name>
```

```bash
# Search a File by Name - case-insensitive 
find -iname <file_name>
```


```bash
# Find a Directory in Linux
find /path/to/search -type d
```

```bash
# Find a Directory in Linux
find /path/to/search -size <size_of_the_file>
find /path/to/search -size +50M -size -100M
```



## License
Distributed under the MIT License. See **[LICENSE][license]** for more information.


[//]: # (Links)
[license]: https://github.com/habibun/miscellaneous/blob/main/LICENSE
