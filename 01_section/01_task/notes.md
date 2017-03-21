### Bash Conditional Statements
[Useful Link](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html)

[Examples in Code (lines 263-310)](http://www.newthinktank.com/2016/06/shell-scripting-tutorial/)

[Shell Script Reference](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links)

` if [ -e "$file1" ]; then
		 echo "$file1 exists"
  fi

	if [ -f "$file1" ]; then
		echo "$file1 is a normal file"
	fi

	if [ -r "$file1" ]; then
		echo "$file1 is readable"
	fi

	if [ -w "$file1" ]; then
		echo "$file1 is writable"
	fi

	if [ -x "$file1" ]; then
		echo "$file1 is executable"
	fi

	if [ -d "$file1" ]; then
		echo "$file1 is a directory"
	fi

	if [ -L "$file1" ]; then
		echo "$file1 is a symbolic link"
	fi

	if [ -p "$file1" ]; then
		echo "$file1 is a named pipe"
	fi

	if [ -S "$file1" ]; then
		echo "$file1 is a network socket"
	fi

	if [ -G "$file1" ]; then
		echo "$file1 is owned by the group"
	fi

	if [ -O "$file1" ]; then
		echo "$file1 is owned by the userid"
	fi`
