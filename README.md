# POSIX Shell Docs & Notes <!-- omit from toc -->

This document is a reference guide for the POSIX Shell programming. It is a bit more than a simple cheat sheet, but it is not a learning book, you need to have some knowledge and experience about Shell programming to understand these notes.

## Table of contents <!-- omit from toc -->

- [Introduction](#introduction)
  - [Script file extension](#script-file-extension)
  - [Shebang line](#shebang-line)
  - [Line ending](#line-ending)
  - [Default shell](#default-shell)
  - [Shells management](#shells-management)
  - [sh options](#sh-options)
- [Basic Syntax](#basic-syntax)
  - [Comments](#comments)
  - [Words and special characters](#words-and-special-characters)
  - [Escaping](#escaping)
  - [Quotes](#quotes)
- [Parameters](#parameters)
  - [Variables](#variables)
  - [Single variable assignments](#single-variable-assignments)
  - [Multiple variable assignments](#multiple-variable-assignments)
  - [Optional single command following the variable assignments](#optional-single-command-following-the-variable-assignments)
  - [Parameter expansion](#parameter-expansion)
  - [Parameter expansion with default](#parameter-expansion-with-default)
  - [Local vs. environment variables](#local-vs-environment-variables)
  - [Built-in parameters](#built-in-parameters)
- [echo vs printf](#echo-vs-printf)
- [Commands](#commands)
- [Background commands](#background-commands)
- [wait command](#wait-command)
- [Flow control](#flow-control)
- [: null command](#-null-command)
- [test command](#test-command)
- [Shell arithmetic](#shell-arithmetic)
- [Functions](#functions)
- [~username/"path with space"](#usernamepath-with-space)
- [Pattern matching (globs or globbing)](#pattern-matching-globs-or-globbing)
- [File commands](#file-commands)
- [Check whether a command is available](#check-whether-a-command-is-available)
- [eval command](#eval-command)
- [Arrays](#arrays)
- [Sourcing with . ./libraryname.sh](#sourcing-with--librarynamesh)
- [exec command](#exec-command)
- [trap command](#trap-command)
- [Strings manipulation](#strings-manipulation)
- [Lines manipulation](#lines-manipulation)
- [getopts](#getopts)


## Introduction

### Script file extension

Shell scripts should have no extension or a `.sh` extension.


### Shebang line

Shell executable scripts start with a Shebang line:

```bash
#!/bin/sh
```

or

```bash
#!/usr/bin/env sh
```

### Line ending

Shell scripts are text files which **must** use the Unix style line ending, that's a single line feed (LF).


### Default shell

- On Debian/Ubuntu `#!/bin/sh` points to dash which is POSIX compliant and similar to the original Bourne shell. The default login shell is bash.

- In MacOSX `#!/bin/sh` points to `/bin/bash` in sh compatibility mode. The default login shell is zsh.

- In Solaris 11 `#!/bin/sh` points to ksh93 which mostly conforms to POSIX. The default login shell is bash.


### Shells management

```bash
cat /etc/shells # see all installed shells
echo $SHELL     # print default login shell
chsh            # see/change default login shell (logout & log back in)
```


### sh options

- Run a script ignoring the Shebang:
  
  ```bash
  sh scriptname.sh args
  ```

  - `-n` reads commands but do not execute them, used to check syntax errors.
  - `-x` traces each command to stderr.
  - `-v` prints script source to stderr.

  Hint: the above options can also be added to the Shebang.


- Start a new shell executing the given command:
  
  ```bash
  sh -c 'cmd "$1" "$2"' "arg0" "arg1" "arg2"
  ```

  - The provided args are handed over to the new shell in `$0`, `$1`, `$2`, ...
  - `"arg0"` is often set to `--` or `sh`.


## Basic Syntax

### Comments

If the current character is a `#`, then `#` itself and all subsequent characters up to, but excluding, the next newline are discarded. The newline that ends the line is not considered part of the comment.

Here-doc into null command to get a multi-line comment:
```bash 
: << 'MULTILINECOMMENT'
This is a multi-line comment
that spans several lines.
MULTILINECOMMENT
```


### Words and special characters

- A word is a sequence of characters considered a single unit by the shell.

- The following special characters do separate words:

  ```bash
  |  &  ;  (  )  <  >  space  tab  newline
  ```

  It follows that spacing between words and those characters doesn't matter.

- The following characters are also special:

  ```bash
  $  `  \  "  '
  ```

- The reserved words must be delimited:

  ```bash
  ! { } case do done elif else esac fi for if in then until while
  ```


### Escaping

For the unquoted case, escaping a single character with a backslash makes it a literal character, and if the escaped character is a normal character, the backslash is removed.

The newline is an exception, if it follows a backslash, the shell interprets this as line continuation (the backslash and the newline are entirely removed and are not replaced by any whitespace).

Avoid confusion, because for certain commands and utilities, escaping a character has an opposite effect, it enables a special meaning. For example `\n` and `\t` are for printf a newline and a tab. 


### Quotes

Quotes are not used to define a string. They are used to disable interpretation of special characters and to prevent reserved words from being recognized as such. Quotes can span multiple lines.

- Single-quotes are strong quotes, they prevent all characters from having special meanings. The only character that cannot occur within single-quotes is the single-quote itself:

  ```bash
  'It'\''s done like that'
  ```

- Double-quotes are weak quotes, they treat most characters as literal characters, but a few of them have a special meaning:

  1. Within double-quotes ``$ ${..} $(..) `..` $((..))`` are interpreted like without quotes, but with the difference that word splitting and pathname globbing do not happen. Moreover the surrounding double-quotes do not conflict with eventual quotes inside of ``${..} $(..) `..` $((..))``.

  2. Within double-quotes the backslash becomes an escape character only if the character following is one of ``$  `  "  \``.  
     Also here, like for the unquoted case, a newline following a backslash is a line continuation (both characters are removed).


## Parameters

A parameter is an entity that stores values and is referenced by a name, a number or a special symbol. Parameters referenced by a name are called variables. Parameters referenced by a number are called positional parameters. Parameters referenced by a special symbol are auto-set parameters. 

### Variables

- There is only the **string** type variable in sh.
- Once a variable is set, it can only be unset with the `unset` command.
- If you refer to a variable name that hasn't been assigned, sh substitutes the empty string.
- sh strings cannot contain the `NUL` (ASCII 0) character.
- A variable name can be made of underscores, numbers and letters (the first character of a variable name cannot be a number).
- By convention, environment variables and internal shell variables are **capitalized**.
- Using **lowercase** variable names for local variables avoids conflicts.


### Single variable assignments

- Simple assignments:
  
  ```bash
  var1='The variable is called $var1'
  var2="and this is the value of it: $var1"
  ```

- Empty string assignment (also called a null string):

  ```bash
  varempty=
  ```

- Here `$var1` is not subject to word splitting and pathname globbing, thus double-quotes around `$var1` are not necessary, but they do not harm:

  ```bash
  var3=$var1
  ```

- The assignment here is literal, no word splitting and no pathname globbing happen:

  ```bash
  var4=*                        
  ```


### Multiple variable assignments

Multiple variable assignments can be placed on one line:

```bash
var1=value1 var2=value2 
```


### Optional single command following the variable assignments

- The variables will be made accessible to a built-in/external command following and will only be valid for that command and its children:

  ```bash
  var1=value1 var2=value2 env
  ```

- On the contrary, if a special built-in command follows, then the variables are not handed over, but they will remain in effect after the special built-in completes.

- The `var=1 echo $var` code is not working because `$var` is interpreted before the execution of `echo`, the solution is a child shell:

  ```bash
  var=1 sh -c 'echo $var'
  ```


### Parameter expansion

Parameter expansion in its simplest form just means variable use:

```bash
$var
"$var"
```

or

```bash
${var}
"${var}"
```

Note: double-quotes prevent the word splitting and the pathname globbing from happening.


### Parameter expansion with default

- If `var` is unset or empty, the expansion of word is substituted:

  ```bash
  ${var:-word}
  ```

- If `var` is unset or empty, the expansion of word is assigned to var. The value of var is then substituted:

  ```bash
  ${var:=word}
  ```

Note: `word` is subject to tilde expansion, parameter expansion, command substitution and arithmetic expansion (but not subject to word splitting and pathname globbing).


### Local vs. environment variables

A sh variable can be either a local variable or an environment variable. They both work the same way; the only difference lies in what happens when the script runs another program. Environment variables are passed to subprocesses, local variables are not (by default variables are local).

```bash
export VAR        # make VAR an environment variable
export VAR=value  # assign and export in one line
unset VAR         # this is the only way to unexport a variable
set               # to view all variables
export -p         # to view the exported variables
```


### Built-in parameters

```bash
$0             # Name of the shell script itself (not affected by shift)
shift [n]      # Drop n positional parameters (default is 1)
$1..$9         # Positional parameters (command line or function)
${10}..        # More positional parameters
$#             # The number of positional parameters without counting $0
               # ($# gets updated with each shift call)
$* and $@      # Positional parameters placed one after the other and 
               # subject to word splitting
"$*"           # Expands to "$1c$2c..." with c being the first char of IFS
"$@"           # Expands to "$1" "$2" ...
$?             # Return exit status of the last command or of a function
$$             # Process id of the shell running the script, in a subshell 
               # $$ is not updated, it returns the parent's PID
$!             # Process id of the most recent background command
```

**Internal Field Separator**

The characters of the `IFS` var are delimiters used to perform the word splitting (also called field splitting).

- IFS whitespaces are any sequence of whitespace characters from the IFS var:
  - IFS whitespaces are ignored at the beginning and end.
  - Adjacent IFS whitespaces are considered a single delimiter.
  - One non-IFS whitespace with adjacent IFS whitespaces are also considered a single delimiter.
- IFS default is space + tab + newline (`unset IFS` to restore default).
- If IFS is set to the empty var, no word splitting is happening.
- To set IFS to a single newline:
  
  ```bash
  nlx=$(printf '\nx') # x needed because $(..) strips trailing newlines
  IFS=${nlx%x}        # remove the above added x and assign to IFS
  ```

## echo vs printf

Nowadays, echo is only portable if flags and escape sequences are omitted. Better to use printf which interprets its escape sequences coherently across the different shell families. 

- Do not use variables in format string:
  
  ```bash
  printf "Hi $var\n"
  ```

  - BAD because `$var` could contain `%s` for example.

- Number:
  
  ```bash
  printf '%02d' 9
  ```

- printf-escapes in format string:
  
  ```bash
  printf '\r\n\t\ddd'
  ```

  - `ddd` is one, two or three-digit octal number.

- char <-> codepoint:

  ```bash
  printf "65 to char: \\$(printf '%03o' 65)\n"
  printf 'A to num: %d\n' "'A"
  ```

  - The leading-quote `'A` instructs printf to show the codepoint.

- printf-escapes in `$var` are not interpreted by `%s`:

  ```bash
  printf '%s' "$var"
  ```

- printf-escapes are interpreted by `%b`:

  ```bash
  printf '%b' '\0ddd'
  ```
  
  - `ddd` is zero, one, two or three-digit octal number.


**Attention**

- Note the difference between the two octal escape formats, to avoid problems with possible numbers following the escape sequence, always use the maximum number of digits for the given format variant.
- Shell's `%b` format specifier behaves like the `%s` format specifier of the C printf. Remember that the `%b` format specifier of the C printf does something different, it prints a number in binary format.


## Commands

- A simple command is a sequence of optional variable assignments 
  followed by blank-separated words and redirections (in simple commands 
  the redirections can also be placed at the beginning) 
- Pipelines are commands combined by pipes that connect the output of 
  the preceding command with the input of the next command 
- A list is a series of pipelines separated by  &  ;  &&  || 
  and terminated by  &  ;  newline 
- If a command returns a zero exit status, the condition is true, 
  otherwise, it is false. By calling the exit [n] command (n defaults to 
  zero) a script exits with code n. There are two programs called true 
  and false, they return respectively with a zero exit status and with a 
  non-zero exit status 
- The exit status of a series of commands is that of the last simple 
  command executed
- The exit status of a variable assignment alone is that of the last 
  substituted command, or zero if there are no command substitutions

Precedence: 
highest         redirection operators
high            |
medium          && || (both carry equal precedence)
lowest          ; &   (both carry equal precedence)

! pipeline      Negates the exit code of the whole pipeline. Being a 
                reserved word, it must be separated by a space. It 
                returns an exit status of 0 if the pipeline exited 
                non-zero, and an exit status of 1, if the pipeline 
                exited zero (supported in POSIX shells, not in the 
                original Bourne shell)
cmd1 | cmd2     Output of cmd1 is piped into cmd2
[n]> file       Output from n is redirected to file, by default 
                n is 1 (stdout), in that case the 1 can be omitted
>/dev/null 2>&1 1 goes to null and 2 (stderr) goes to what 1 refers to 
                at this moment (that's null). The order of these two 
                redirections matters here 
[n]>> file      Output from n appended to file 
                (n can be omitted if it is 1)
[n]< file       Input from file into n, by default n is 0 (stdin), 
                in that case the 0 can be omitted
[n]<< ENDTXT    Redirect into n from current script point until ENDTXT 
                $ ${..} $(..) $((..)) are interpreted
                (n can be omitted if it is 0)
[n]<< 'ENDTXT'  Redirect into n from current script point until ENDTXT 
                $ ${..} $(..) $((..)) are NOT interpreted
                (n can be omitted if it is 0)
cmd1 && cmd2    Execute cmd1. Then, if it exited with a zero exit status 
                (true), execute cmd2
cmd1 || cmd2    Execute cmd1. Then, if it exited with a non-zero exit 
                status (false), execute cmd2
cmd1; cmd2      Do cmd1 and then cmd2
cmd1 & cmd2     Do cmd1, start cmd2 without waiting for cmd1 to finish
                (see Background commands)
{ cmds; }       Group cmds, the last semicolon is required because cmds
                is a list, and the first curly bracket must be separated 
                by a space because it is a reserved word. Often used to 
                change precedence 
(cmds)          Run cmds in a subshell, blocks until subshell is done
$(cmds)         Command substitution runs cmds in a subshell, the output 
                replaces $(cmds). $(cmds) is supported in POSIX shells 
                and must be preferred over the obsolete `cmds` syntax 
                which has nesting problems 
                Note: trailing newlines are removed from command output 

Signal 13 termination:
It means that something is written to a pipe, but nothing is read. It 
often happens when a head command already got all the input it wants 
and closed its input pipe, while the source command is still writing 
into its output pipe. To hide the message, add to the source command: 
2>/dev/null

Compound commands, like command groups, while loops or functions, can be 
part of a pipeline or can also be redirected:
- The pipe operator is placed before the compound command or at the end 
  on the same line as the terminator. In POSIX shells each compound 
  command of a pipeline runs in a separate subshell. 
  For example: cat file.txt | while read l; do printf '%s\n' "$l"; done
- Redirections have to be placed at the end on the same line as the 
  terminator. Each redirection is applied to all the commands within the 
  compound command that do not explicitly override that redirection. 
  For example: { cmd1; cmd2; } > file.txt


## Background commands

When executing a command the shell normally creates a new process and 
waits for it to finish. A command may be run without waiting for it to 
finish by appending a & like: sleep 1000 & 
To put a running job into background stopping it press: Ctrl+Z 
A job is a process that the shell manages: 
jobs            # to see the running background jobs with their job num 
fg %n           # move the job to foreground (re-started if stopped)
bg %n           # re-start a stopped job in background
kill %n         # kill the given job
Note: for background commands the stdin is detached (not for subshells). 


## wait command

wait [PIDs]

- Without arguments it waits until all child processes terminate 
  (wait exits with a zero exit status)
- If PIDs are given, it waits until all listed processes have terminated 
  (wait exits with the exit status of the last listed PID)
  wait works only for shell child processes, but it's possible to use 
  kill to poll for the existence of an arbitrary process:
  kill -0 $pid


## Flow control

list+words must be terminated by ; or newline:
if list then list elif list then list else list fi
while list do list done
until list do list done               # like while but test is inverted
for varname in words do list done
Notes:
- for varname in "$@" has a short form: for varname
- while, until or for may contain break and continue

word+pattern not subject to word splitting and pathname globbing:
case word in pattern | pattern ) list;; pattern | pattern ) list;; esac
Note: pattern can contain unquoted globs used to match the given word


## : null command

if who | grep -q jane
then
    :    # returns an exit status of 0
else
    echo "jane is not currently logged on"
fi
Note: both the null command and true return 0, for code clarity a good 
      habit is to use : for empty commands and true in conditions.


## test command

[ and test are almost the same command, the only difference is that [ 
expects its last argument to be ]
As [ is actually a command, it's necessary to add a space after [ and 
also before ] because that's the last argument of [

-r file         Check whether file is readable
-w file         Check whether file is writable
-x file         Check whether we have execute access to file
-f file         Check whether file is a regular file 
-s file         Check whether file has size greater than 0
-d file         Check whether file is a directory
-e file         Check whether file exists (true even if file is a dir)
-t fd           Check whether file descriptor number is open and is 
                associated with a terminal

"$var" = "str"  Check whether the same (space needed before/after =)
"$var" != "str" Check whether they differ (space needed before/after !=)
-z "$var"       Check whether var has size 0 (does not distinguish 
                between an unset var and a var that is empty) 
-n "$var"       Check whether var has non-zero size
"$var"          Equivalent to -n "$var" 

There is no test for substrings, for that we use grep: 
echo "$var" | grep -q "sub1"

A shell variable can contain a string that represents a number:
$num -eq 2      Check whether num equals 2
$num -ne 2      Check whether num is not equal to 2
$num -lt 2      Check whether num < 2
$num -le 2      Check whether num <= 2
$num -gt 2      Check whether num > 2
$num -ge 2      Check whether num >= 2

To negate an expression use ! (needs a space after it). It can also be 
placed outside the test command (pipeline negation)

To combine expressions do not use the obsolete -a (and) and -o (or) 
options, instead use two tests combined with && and ||

For grouping do not use test command's obsolete \( \), instead implement 
multiple tests in braces like:
[ -e file1 ] &&  { [ -x file2 ] || [ -x file3 ]; }


## Shell arithmetic

In the original Bourne shell, arithmetic is done using the expr command:
result=$(expr $var1 + 2)
result=$(expr $var2 + $var1 / 2)
result=$(expr $var2 \* 5)          # note that * has to be escaped
count=$(expr $count + 1)

The POSIX shells have arithmetic expansion where specifying the 
variables with $ or ${} is optional (exceptions are $1, $2, ... ):
result=$((var1 + 2))
result=$((var2 + var1 / 2))
result=$((var2 * 5))
count=$((count + 1))

The above two methods only support integer operations,
for floating-point we have the basic calculator command:
var1=12.5
var2=6.0
echo "$var1 + $var2" | bc


## Functions

myfunc1()            # function definitions must happen before their use
{
    provided_username=$1
    provided_password=$2
    return 2
}
myfunc1 "myusername" "mypassword"
if [ "$?" -eq "2" ]
then
    echo 'OK!'
fi

myfunc2() { echo "Hi"; }  # add a semicolon because shell expects a list
result=$(myfunc2)
echo $result

- Except for $1, $2, ... which are the params passed to the function and 
  not the original ones, all script variables can be read and written 
- Use return to end the function, returned value can be read with $? 
  (exit status of last command is returned when no return is specified) 
- echo in function does write to stdout, that can be caught with $(..) 


## ~username/"path with space"

1. A word that begins with an unquoted tilde + an optional unquoted 
   username will expand to the home directory. If a path follows, then 
   also the first slash must be unquoted. If the username is invalid, 
   or the tilde expansion fails, the word is left unchanged 
2. Tilde expansion happens in variable assignments 
3. The result of a parameter expansion is never tilde expanded 
   (that's because tilde expansion happens before parameter expansion) 
4. The pathname resulting from a tilde expansion is treated as if quoted 
   to prevent it being altered by word splitting and pathname globbing 


## Pattern matching (globs or globbing)

Unquoted globs meaning:
*              Matches 0 or more characters
foo*           Matches any string beginning with foo
*x*            Matches any string containing an x (begin, middle or end)
*.tar.gz       Matches any string ending with .tar.gz
?              Matches 1 character
[AaBbCc]       Matches 1 char from the list
[!RGB]         Matches 1 char not in the list
[a-g]          Matches 1 char from the range
[CHARCLASS]    Matches 1 char from the given POSIX character class
               Examples: [[:space:]] or [![:space:]] 

Pathname expansion has additional rules:
1. Non-matching globs are expanded to themselves, always test a match 
   for existence with -e
2. Glob patterns do not match slashes and do not cross the slashes 
   that separate pathname components 
3. Even if a filename contains spaces, tabs, newlines, quotes, the 
   expansion of a glob that matches that filename will still preserve 
   each filename as a single word 
4. Filenames beginning with a dot can only be matched by patterns that 
   also start with a dot. To not match current dir and parent dir use:
   .[!.]* ..?*
5. A glob that ends in / will only match directories, the / will be 
   included in the result 
Hint:
Use ./* instead of * so filenames with dashes won't become options!


## File commands

basename 'path'
Trailing slash is trimmed from the given path and then the rightmost 
part of that is printed. 
Exception: if path is / then basename returns /

dirname 'path'
It's the complement of basename, it prints what basename does not print 
(the ending slash is trimmed if dirname is not / alone)
Exception: if path is / then dirname returns /

mktemp
Makes a unique temporary filename and prints it to stdout. Usually it 
also gets created with size 0 (only some older systems do not create it).
The -d option creates a temporary directory instead of a file. 
mktemp is not POSIX, but supported by most systems: 
mytempfile=$(mktemp)
mytempdir=$(mktemp -d)

: > 'path'
Used to truncate a file to zero length


## Check whether a command is available

```bash
if command -v cmd >/dev/null 2>&1
then
    echo "cmd exists."
else
    echo "cmd not found."
fi
```


## eval command

eval [args]
In simple terms with eval a given input is parsed twice. In detail, eval 
concatenates the arguments (which may have been expanded) with spaces, 
and then it instructs the shell to execute the result. The exit status 
of eval is the exit status of what has been run by the shell. 


## Arrays

In POSIX there is no native array type, but there are different 
possibilities. To be coherent with the positional parameters and with 
tools like cut, sed, awk, sort, one-based indexing is used here.

1. Space separated string (if elements have no spaces):
array='0 1.3 4.2 6 8.7 16.2'           # init array
array='-1 '$array                      # add to start
array=$array' 32.1'                    # append to end
item=$(echo "$array" | cut -d' ' -f$i) # get item with index $i
for item in $array                     # loop array
do
    printf '"%s"\n' "$item"
done

2. Using positional parameters (gives us only one array):
set --                                 # clear all
set -- ./*                             # fill with files
set -- 'Item 1' 'Item 2' 'Item 3'      # add items (array is cleared)
set -- 'Item start' "$@"               # add to start
set -- "$@" 'Item end'                 # append to end
eval "item=\${$i}"                     # get item with index $i
shift 1                                # delete first item
for item in "$@"                       # loop array
do
    printf '"%s"\n' "$item"
done

3. Using multiple shell variables:
len=3 n=1
while [ $n -le $len ]                  # create items
do
    eval "array$n=\"Item ${n}\""
    n=$((n+1))
done
eval "item=\$array$i"                  # get item with index $i
n=1
while [ $n -le $len ]                  # loop array
do
    eval "item=\$array$n"
    printf '"%s"\n' "$item"
    n=$((n+1))
done


## Sourcing with . ./libraryname.sh

When a script is included with the dot command, it runs within the 
existing shell. Any variables created or modified by the script will 
remain available after it completes. In contrast, if a script is run 
normally, then a separate subshell (with a completely separate set of 
variables) is spawned to run the script. In POSIX the dot command does 
not support passing arguments to the called script (pass them as vars). 

Convention: libraries should have a .sh extension and should not be 
            executable. The Shebang is not necessary, but for syntax 
            highlighting and for ShellCheck it's better to have it. 

Note: source is a synonym for the dot command in bash, but not in POSIX. 


## exec command

exec [cmd [args]] [redirections]

If a cmd is specified, exec replaces the shell with cmd without creating 
a new process, thus the commands following the exec line will be 
ignored. If cmd is not specified, any redirections take effect in the 
current shell. The redirections can be used to open, close or copy 
file descriptors (abbreviated with fd):
exec 3< file    # open file as fd 3 for reading
exec 4> file    # open file as fd 4 for writing
exec 5<> file   # open file as fd 5 for reading/writing
exec 6>> file   # open file as fd 6 for appending
exec 7<&0       # duplicate stdin as fd 7
exec 7<&-       # close fd 7 to free it for other processes to use


## trap command

trap action signals

action: 
- a dash as an action resets each given signal to its default action 
- a function as an action is called for the given signals
- commands as an action are executed for the given signals:
  1. If the commands are placed in double-quotes all expansions will 
     happen when the trap is defined
  2. If the commands are placed in single-quotes all expansions will 
     happen when the trap is executed

signals (space separated):
INT (2)   sent when the user presses Ctrl+C
TERM (15) default kill signal (sent when you call kill)
HUP (1)   hang up has about the same harshness as TERM
          (sent when a user disconnects from the terminal)
QUIT (3)  harshest of the ignorable signals
EXIT (0)  sent when the script exits at the end or with the exit command
Note: the KILL (9) signal cannot be handled with a trap. 

Attention: the default trap actions usually restore the tty to a sane 
           state, but if you setup your own trap actions then you have 
           to revert tty changes in them. 


## Strings manipulation

Count the chars:
wc -m              # -c counts the bytes
or:
str_length=${#var} # some shells still return bytes instead of chars

Print the numeric sequence from FIRST to LAST with space separator:
seq -s ' ' FIRST LAST

To concatenate strings write them attached to each other:
ADDEDSTR=${var1}mytext'with space'"and $var2"

Remove prefix/suffix strings:
noprefix=${var#word}     # remove smallest prefix match
nosuffix=${var%word}     # remove smallest suffix match
noprefix=${var##word}    # remove largest prefix match
nosuffix=${var%%word}    # remove largest suffix match
Note: place word in quotes to prevent glob characters in it from being 
      used to match the content of var

cut strings or cut each line of a given file:
cut -c LIST [filename]
cut -d DELIM -f LIST [filename]
DELIM is a single character that splits the string (default is TAB),
that same character is also used to separate the output fields 
LIST is made up of one range, or many ranges separated by commas: 
N      N'th, it uses one-based indexes
N-M    from N'th to M'th
N-     from N'th to end
Note: cut always appends a newline at the end

rev(erse) lines:
echo 'Hello World!' | rev | cut -c 2- | rev     # removes the last char
Note: the ending newlines are not reversed, and if no ending newline is 
      present, then rev does not append one 

awk (separators are more flexible compared to cut):
- Fields are columns of data and records are rows of data 
- awk strings must be enclosed in double-quotes, not in single-quotes 
  (single-quotes have no special meaning in awk) 
- awk concatenates strings, numbers or vars when placing them next to 
  one another (sometimes a space may be required to distinguish them) 
- Vars in awk are assigned like in shell, but used without dollar sign 
- Use the -v option to pass shell vars to awk 
awk 'cond1{action1;action2}cond2{action3;action4}' input.txt
awk 'BEGIN {print "START"}'   # BEGIN is run before any records are read
awk 'END {print "STOP"}'      # END is run after the last record is read
awk '{print $1}'              # print first field, one-based index
awk '{print $1 $3}'           # print fields 1 and 3 with no separation
awk '{print $1,$3}'           # print fields 1 and 3 separated by OFS
awk '{print $(NF-1),$NF}'     # print second last and last fields
awk '{print NR":"NF,$0}'      # record num and num of fields in record
awk '{print}'                 # print all with FS (same as print $0)
awk '{$1=$1; print}'          # print all with OFS
                              # $1=$1 forces record to be rebuilt
awk '{action with no print}1' # 1 is true and default action is print
awk '{$2="new" OFS $2}1'      # insert a field in second position
awk '{$(NF+1)=$1+$2}1'        # append a field which is the sum $1+$2
awk '{for(i=3;i<NF;i++)printf "%s%s",$i,OFS;print $NF}' # fields range
awk 'NR>1 && NR<=3'           # records range
awk '(NR % 2) == 0'           # even records
The variable assignment option (we can use multiple of them):
-v FS=' '   single char or extended regular expression, default input 
            field separator is a single space, that has a special 
            meaning for awk: leading/trailing whitespaces are ignored 
            and fields are separated at chains of contiguous 
            whitespaces. If just a literal space is wished as separator, 
            then it has to be specified as character class: FS='[ ]' 
            A multi-space/tab separator could be: FS='[ ]{2,}|\t' 
            For FS= the behavior is unspecified! 
            Alias: can also be written as -F ' ' 
-v RS='\n'  single character, default input record separator is a 
            newline. If FS and RS are the same, RS wins, that's because 
            awk needs to determine the record first, then it can break 
            the record into fields. 
            With RS= records are separated by one or more empty lines 
            and leading/trailing empty lines are ignored (paragraph mode) 
-v OFS=' '  string, default output field separator is a single space
-v ORS='\n' string, default output record separator is a newline

tr (operate on character sets):
echo "Str" | tr [a-z] [A-Z]     # lowercase to uppercase
echo "Str" | tr [:space:] '\t'  # any whitespace to a tab
echo "a{12}" | tr '{}' '()'     # transform braces into parentheses
printf 'N\nL\n' | tr -d '\n'    # delete all newlines
echo "Str" | tr -d 'St'         # delete a set of chars
echo "Str  Hi" | tr -s ' '      # squeeze chars leaving one occurrence

sed (replace a string):
- sed reads one line at a time and if a trailing newline is present, it 
  removes it. When sed is done, it re-adds the trailing newline, but 
  only if it was already there 
- The character after the s is the delimiter; conventionally it is a 
  slash, but you can take whatever is not in your strings 
echo 'This is the OldString' | sed 'N,M s/OldString/NewString/g'
sed 's/OldString/NewString/g' input.txt
echo 'hi!' | sed 's/.$//'       # removes the last char
echo 'These are 12 34 2140' | sed 's/[0-9]/N/g'
echo 'hi  there!' | sed -E 's/([a-z]*)[[:space:]]+([a-z]*).*/\1 \2/g'
s      substitute
g      global, without it, sed will only replace the first occurrence 
       on each line (remember that you always need three delimiters)
N      N'th line, it uses one-based indexes
N,M    from N'th to M'th line
N,$    from N'th to end line
&      placeholder, you can have any number in the replacement string
\1..\9 placeholders for the (..) matches, use -E to not escape (..)
-i     ATTENTION: that edits given file in-place; sed has no 
       case-insensitive matching option!
-E     is for extended regular expression, for example if needing + ? |

In regex use POSIX character classes:
[[:space:]] instead of \s (space, tab, newline, carriage return)
[[:blank:]] space and tab
[[:word:]]  instead of \w or [a-zA-Z0-9_]
[[:alnum:]] instead of [a-zA-Z0-9]
[[:alpha:]] instead of [a-zA-Z]
[[:digit:]] instead of \d or [0-9]
[[:lower:]] instead of [a-z]
[[:upper:]] instead of [A-Z]
Note: don't confuse the "POSIX character class" with what is normally 
      called a "regex character class". [x-z0-9] is an example of a 
      "regex character class" which POSIX calls a "bracket expression". 
      [:digit:] is a "POSIX character class", used inside a "bracket 
      expression" like [x-z[:digit:]]


## Lines manipulation

Sort the lines of a text:
sort  # -n numerically, -u suppress duplicated lines, -r reverse sort

Count the lines:
wc -l
 
Show the first N lines:
head -n N

Show the last N lines:
tail -n N

Get N'th line:
head -n N | tail -n 1

Output the lines matching the given regex:
grep 'HI' [filename]
-i     ignore case
-w     match whole words only
-v     invert the match (it hides the matching lines)
-E     is for extended regular expression, for example if needing + ? |
       (egrep is obsolete, the -E option is the way to go)

Wrap lines:
fold [filename]
-s     break at blank characters
-w N   break at the given amount of column positions (default: 80)

Compare files line by line:
diff left right       # exit status of 0 if no differences found
LaR    add lines in R-range of right file after line L of left file
LcR    change L-range of left file with R-range of right file
LdR    delete lines in L-range from left file, if not deleted they would 
       have appeared after line R in right file
-C N   N-lines of context output (-c short form for -C 3)
-U N   N-lines of unified context output (-u short form for -U 3)
       Note: the number after the comma is the count, not the range end

read [-r] vars
- The read result (terminating newline removed) is field split to the 
  given vars according to the IFS. If there are fewer fields than there 
  are vars, the remaining vars are set to the empty string. If there are 
  fewer vars than fields, the last var will be set to the remaining 
  fields with trailing IFS whitespaces removed 
- By default read will interpret backslashes as escape characters. This 
  is rarely desired. Normally you just want to read data, including 
  backslashes as part of the input string, that is what read -r does 

Get user input:
printf 'Do you want to continue (y/N) ? ' # capitalized answer in (y/N) 
read -r answer                            # is considered the default 
if [ "$answer" != "${answer#[Yy]}" ]      # when just ENTER is pressed 
then
    echo Yes
else
    echo No
fi

Read line by line:
while IFS= read -r line || [ -n "$line" ]
do
    printf '%s\n' "$line"
done < "$filename"
- Clear IFS to prevent leading/trailing whitespaces from being trimmed 
- read always places the last line into the variable, but returns a 
  nonzero status if no ending newline is found, thus || [ -n "$line" ] 
  is necessary to make sure that the last line is gotten 


## getopts

According to POSIX, options are single alphanumeric characters preceded 
by a hyphen, they can have an optional option-argument following it 
separated by optional whitespaces. Multiple options may follow a hyphen 
if the options do not take option-arguments. After the options, 
non-option arguments, also called operands, may follow. getopts supports 
the POSIX guideline of explicitly marking the end of the options with 
the -- delimiter. It is not mandatory to provide this double-dash, just 
make sure that the first non-option argument does not start with a 
hyphen. For example, if this first non-option argument is a glob, then 
there is a chance that the first expanded filename starts with a hyphen. 
Note: bear in mind that not all UNIX commands support the -- convention 

getopts "aZ" opt    # expected are -a and -Z with no option-args
getopts "aZ:" opt   # colon after an option means it has an option-arg
getopts ":aZ:" opt  # colon in first position means that we handle the
                    # case when an invalid option was provided and the 
                    # case when no option-arg was passed
while getopts ":aZ:" opt
do
  case $opt in
     a)
       echo "Option -a called"
       ;;
     Z)
       echo "Option -Z called with $OPTARG"
       ;;
     \?)
       echo "*** Invalid Option -$OPTARG ***"
       ;;
     :)
       echo "*** Option -$OPTARG requires an Option-Argument ***"
       ;;
     *)
       echo "*** SHOULD NEVER LAND HERE ***"
       ;;
  esac
done
if [ $OPTIND -eq 1 ]
then 
    echo "No Options were passed"
fi
shift $((OPTIND-1))
echo "$# Non-Option Argument(s) (also called Operand(s)) follow:"
for operand in "$@"
do
    echo "$operand"
done
