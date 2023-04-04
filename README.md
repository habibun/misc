## About The Project
Miscellaneous  

## Context

### [Nginx](nginx)
### [Template](template)
### [Script](script)
### [Phpstorm](phpstorm)
### [Makefile](makefile)

--- 
## Command

<details>

<summary>Size</summary>

[//]: # (### You can add a header)

`df -h` # hard drive free space   
`du -hs /path` # size of a directory   
`du -hs /path/*` # size of a all directory inside   
`du -hs /path/* | sort -rh` # size of a all directory inside and sort by size desc

</details>

<details>

<summary>Terminal</summary>

[//]: # (### You can add a header)

`command & disown` # cmd should be started in an independent terminal


</details>

<details>

<summary>File</summary>

[//]: # (### You can add a header)

`truncate -s 0 file` # empty log files  
`unrar x -r file.rar` # unpack files


</details>


<details>

<summary>Search</summary>

[//]: # (### You can add a header)

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


</details>



<details>

<summary>Xdebug</summary>

[//]: # (### You can add a header)

`sudo phpdismod xdebug` # disable xdebug  
`sudo phpenmod xdebug` # enable xdebug


</details>

[Learn More](./command)

## License
Distributed under the MIT License. See **[LICENSE][license]** for more information.


[//]: # (Links)
[license]: https://github.com/habibun/miscellaneous/blob/main/LICENSE
