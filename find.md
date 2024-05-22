# find

`find` supports recursive file listing with many filtering options, it lists also hidden/dot files (if not limited by a shell glob).

```bash
find [paths] [expression]
```

- It's possible to provide single or multiple paths, absolute or relative. If no path is provided it defaults to `.`
- An expression is a series of operands combined with operators. If an expression does not contain an `-exec` or a `-print` action-operand, it will default to `\( expression \) -print`

### In order of decreasing precedence we have the following operators

1. `\( ... \)` the grouping operator (space before and after the escaped parentheses).
2. `! opd` the NOT operator.
3. `opd1 -a opd2` the AND operator, `opd2` is not evaluated if `opd1` is false (`-a` can be omitted because it is the **default operator**).
4. `opd1 -o opd2` the OR operator, `opd2` is not evaluated if `opd1` is true.

### Common operands

#### Name and type

- `-name 'NAME'` matches the basename of the current pathname. As opposed to shell globbing, `*` and `?` in `'NAME'` can also match names with a leading dot.  
  Important: avoid the shell globbing by always surrounding the `-name` argument by quotes.
- `-path 'PATH'` is like `-name` but it must match the current pathname.  
  To exclude current directory: `find . ! -path . -type d`  
  To exclude a directory: `find . ! -path '*/dir/*'`
- `-type f` to match regular files and `-type d` for directories.  
  Hint: use `-name` before `-type` to avoid a `stat` call on every file.

#### Size

Always append `c` to specify the size in bytes.

- `-size NUMc` is true if file size is the given `NUM` of bytes.
- `-size +NUMc` is true if file size is greater than the given `NUM` of bytes.
- `-size -NUMc` is true if file size is less than the given `NUM` of bytes.

#### Time

The initialization time is just before any file processing starts.  
`days = (init. time sec - modif. time sec) / 86400` with remainder discarded.

- `-mtime n` is true if days = n, for example `-mtime 2` means between 48h-72h ago.
- `-mtime +n` is true if days > n, for example `-mtime +1` means at least two days ago.
- `-mtime -n` is true if days < n, for example `-mtime -1` means in the last 24h.

#### Permissions

- `-perm mode` is true if the file's permissions are exactly `mode` (octal or symbolic).
- `-perm -mode` is true if all permission bits of `mode` are set for the file (file can have additional permission bits set).

#### User/group

- `-user uname` is true if the file belongs to the user `uname`.
- `-group gname` is true if the file belongs to the group `gname`.

#### Prune (do not descend directory)

- `-prune` always evaluates as true and it instructs `find` to not descend the current pathname if it is a directory.  
Only files in `.`: `find . -type f -print -o -type d -prune`  
Exclude a directory: `find . -path /dir -prune -o -print`

#### Print

- `-print` always evaluates as true and it prints the pathname (appending a newline) exactly at the moment it gets evaluated in the expression. The position matters:  
Prints everything: `find . -print -type d`  
Prints only directories: `find . -type d -print`

#### Execute for each pathname

- `-exec cmd [args] \;` evaluates as true if the exit status of the executed command is 0. The `{}` pathname placeholder can be provided multiple times, in arguments position or even as the command. The `\;` is to mark the end of `-exec`.
- `-exec sh -c 'cmd1 "$1" | cmd2' -- {} \;` invokes a child shell to be able to employ shell operators.

#### Execute with as many as possible pathnames

`find` does not exceed the system's `ARG_MAX` limit, if necessary, it calls the command multiple times:

- `-exec cmd [args] {} +` always evaluates as true. The placeholder for the found pathnames is `{}`. The `+` is to mark the end of `-exec`.

## Alternative

If `find` is not available, `du -a` and `ls -alR` can do recursive file find.
