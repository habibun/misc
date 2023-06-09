## About The Project
Miscellaneous  

## Context

### [Nginx](nginx)
### [Script](script)
### [Phpstorm](phpstorm)
### [Makefile](makefile)
### [Bash](bash)
### [Readme](readme)
##


## Command

<details>

<summary>Size</summary>

[//]: # (### You can add a header)

```bash
# hard drive free space
df -h 
```

```bash
# size of a directory
du -hs /path   
```

```bash
# size of a all directory inside
du -hs /path/*   
```

```bash
# size of a all directory inside and sort by size desc
du -hs /path/* | sort -rh
```
##

</details>

<details>

<summary>Terminal</summary>

[//]: # (### You can add a header)

```bash
# cmd should be started in an independent terminal
command & disown
```

##

</details>

<details>

<summary>File</summary>

[//]: # (### You can add a header)

```bash
# empty log files  
truncate -s 0 file
```

```bash
# unpack files 
unrar x -r file.rar 
```
##

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
##
</details>


<details>

<summary>Xdebug</summary>

[//]: # (### You can add a header)

```bash
# enable xdebug
sudo phpenmod xdebug
```

```bash
# disable xdebug
sudo phpdismod xdebug  
```
##

</details>

[Learn More](./command)


## Other
- [How to read your way to becoming a better developer](https://www.freecodecamp.org/news/how-to-read-your-way-to-becoming-a-better-developer-b6432fa5bc0c/)
- [mkcert](https://github.com/FiloSottile/mkcert)  



## License
Distributed under the MIT License. See **[LICENSE][license]** for more information.


[//]: # (Links)
[license]: https://github.com/habibun/miscellaneous/blob/main/LICENSE
