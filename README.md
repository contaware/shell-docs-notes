# POSIX Shell Docs & Notes <!-- omit from toc -->

This document is a reference guide for POSIX Shell programming. It is a bit more than a simple cheat sheet, but it is not a learning book, you need to have some knowledge and experience about Shell programming to understand these notes.

All the documents are licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/), while **our code snippets/examples are in public domain** because they do not meat the threshold of originality. Bear in mind that if two programmers provide substantially the same code snippets/examples for a given task, then that's considered non-original. Nevertheless, to reassure everyone, we explicitly release our code snippets/examples into the public domain under the [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) license.


## Table of contents <!-- omit from toc -->

- [Basics](#basics)
  - [File extension and line ending](#file-extension-and-line-ending)
  - [Shebang line](#shebang-line)
  - [Default shell and management](#default-shell-and-management)
  - [sh options](#sh-options)
  - [echo vs printf](#echo-vs-printf)
- [Syntax](#syntax)
  - [Comments](#comments)
  - [Words and special characters](#words-and-special-characters)
  - [Escaping](#escaping)
  - [Quotes](#quotes)
- [Parameters](#parameters)
  - [Introduction](#introduction)
  - [Variables](#variables)
  - [Single variable assignments](#single-variable-assignments)
  - [Multiple variable assignments](#multiple-variable-assignments)
  - [Command after variable assignments](#command-after-variable-assignments)
  - [Parameter expansion](#parameter-expansion)
  - [Parameter expansion with default](#parameter-expansion-with-default)
  - [Local vs environment variables](#local-vs-environment-variables)
  - [Built-in parameters](#built-in-parameters)
- [Commands](#commands)
  - [Simple command to list](#simple-command-to-list)
  - [Compound commands](#compound-commands)
  - [Background commands](#background-commands)
  - [wait](#wait)
- [Flow control](#flow-control)
  - [if, while, until, for and case](#if-while-until-for-and-case)
  - [null command](#null-command)
  - [test](#test)
- [Shell arithmetic](#shell-arithmetic)
- [Functions](#functions)
- [Tilde expansion](#tilde-expansion)
- [Pattern matching (globs or globbing)](#pattern-matching-globs-or-globbing)
- [Advanced](#advanced)
  - [Command available?](#command-available)
  - [eval](#eval)
  - [dot command](#dot-command)
  - [exec](#exec)
  - [trap](#trap)
- [Manipulation](#manipulation)
  - [Files](#files)
    - [basename](#basename)
    - [dirname](#dirname)
    - [Make temporary file/directory](#make-temporary-filedirectory)
    - [Truncate to zero length](#truncate-to-zero-length)
  - [Strings](#strings)
    - [Count characters](#count-characters)
    - [Print numeric sequence](#print-numeric-sequence)
    - [Concatenate strings](#concatenate-strings)
    - [Test for substring](#test-for-substring)
    - [Remove prefix/suffix strings](#remove-prefixsuffix-strings)
    - [tr (operate on character sets)](#tr-operate-on-character-sets)
  - [Lines](#lines)
    - [Sort lines](#sort-lines)
    - [Count lines](#count-lines)
    - [Show first N lines](#show-first-n-lines)
    - [Show last N lines](#show-last-n-lines)
    - [Get N'th line](#get-nth-line)
    - [grep lines](#grep-lines)
    - [Wrap lines](#wrap-lines)
    - [Read input](#read-input)
    - [User input](#user-input)
    - [Read line by line](#read-line-by-line)
  - [diff](#diff)
  - [cut](#cut)
  - [awk](#awk)
  - [sed](#sed)
  - [POSIX character classes](#posix-character-classes)
  - [getopts](#getopts)


## Basics

### File extension and line ending

- Shell scripts should have no extension or a `.sh` extension.

- Shell scripts are text files which **must** use the Unix style line ending, that's a single line feed (LF). In shell programming a newline is a LF.


### Shebang line

Shell executable scripts start with a Shebang line:

```bash
#!/bin/sh
```

or

```bash
#!/usr/bin/env sh
```


### Default shell and management

- On Debian/Ubuntu `#!/bin/sh` points to dash which is POSIX compliant and similar to the original Bourne shell. The default login shell is bash.

- In MacOSX `#!/bin/sh` points to `/bin/bash` in sh compatibility mode. The default login shell is zsh.

- In Solaris 11 `#!/bin/sh` points to ksh93 which mostly conforms to POSIX. The default login shell is bash.


```bash
cat /etc/shells   # see all installed shells
echo $SHELL       # print default login shell
chsh              # see/change default login shell
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


- Start a child shell that executes the given cmd, and then wait until it's done:
  
  ```bash
  sh -c 'cmd "$1" "$2"' "arg0" "arg1" "arg2"
  ```

  - The provided args are handed over to the new shell in `$0`, `$1`, `$2`, ...
  - `"arg0"` is often set to `--` or `sh`


### echo vs printf

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


## Syntax

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

  1. Within double-quotes ``$ ${..} $(..) `..` $((..))`` are interpreted like without quotes, but with the difference that word splitting and pathname globbing do not happen. Moreover the surrounding double-quotes do not conflict with eventual quotes inside of ``${..} $(..) `..` $((..))``

  2. Within double-quotes the backslash becomes an escape character only if one of these ``$  `  "  \`` follow. Also here, like for the unquoted case, a newline following a backslash is a line continuation (both characters are removed).


## Parameters

### Introduction

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


### Command after variable assignments

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

- If `var` is unset or empty, the expansion of `word` is substituted:

  ```bash
  ${var:-word}
  ```

- If `var` is unset or empty, the expansion of `word` is assigned to var. The value of `var` is then substituted:

  ```bash
  ${var:=word}
  ```

Note: `word` is subject to tilde expansion, parameter expansion, command substitution and arithmetic expansion (but not subject to word splitting and pathname globbing).


### Local vs environment variables

A sh variable can be either a local variable or an environment variable. They both work the same way; the only difference lies in what happens when the script runs another program/script. Environment variables are passed to sub processes/child processes/child shells, local variables are not (by default variables are local).

```bash
export VAR        # make VAR an environment variable
export VAR=value  # assign and export in one line
unset VAR         # this is the only way to unexport a variable
set               # to view all variables
export -p         # to view the exported variables
```


### Built-in parameters

```bash
$0                # Name of the shell script (not affected by shift or set)
$1..$9            # Positional parameters (command line or function)
${10}..           # More positional parameters
$#                # The number of positional parameters without counting $0
                  # ($# gets updated with each shift call)
$* and $@         # Positional parameters placed one after the other and 
                  # subject to word splitting and pathname globbing
"$*"              # Expands to "$1c$2c..." with c being the first char of IFS
"$@"              # Expands to "$1" "$2" ...
$?                # Return exit status of the last command or of a function
$$                # Process id of the shell running the script
                  # (in a subshell $$ remains the same)
$!                # Process id of the most recent background command
```

**Manipulate positional parameters**

```bash
set --                     # Clear all
set -- 'Item 1' 'Item 2'   # Set new ones
set -- 'Item start' "$@"   # Add to start
set -- "$@" 'Item end'     # Append to end
shift [n]                  # Drop the first n (default is 1)
```

Note: `set` and `shift` called outside a function, will manipulate the positional parameters from the command line. When called inside a function, they will manipulate the positional parameters of that function.

**Internal Field Separator**

The characters of the IFS variable are delimiters used to perform the word splitting (also called field splitting).

- IFS whitespaces are any sequence of whitespace characters from the IFS variable:
  - IFS whitespaces are ignored at the beginning and end.
  - Adjacent IFS whitespaces are considered a single delimiter.
  - One non-IFS whitespace with adjacent IFS whitespaces are also considered a single delimiter.
- IFS default is space + tab + newline (`unset IFS` to restore default).
- Setting IFS to empty/null will disable the word splitting: `IFS=`
- To set IFS to a single newline:
  
  ```bash
  nlx=$(printf '\nx')  # x needed because $(..) strips trailing newlines
  IFS=${nlx%x}         # remove the above added x and assign to IFS
  ```


## Commands

### Simple command to list

- A simple command is a sequence of optional variable assignments followed by blank-separated words. Redirections can appear anywhere in a simple command.
- Pipelines are commands combined by pipes that connect the output of the preceding command with the input of the next command.
- A list is a series of pipelines separated by `&  ;  &&  ||` and terminated by `&  ;  newline`
- If a command returns a zero exit status, the condition is true, otherwise, it is false. By calling `exit n` (n is optional and defaults to zero) a script exits with code n. There are two programs called `true` and `false`, they return respectively with a zero exit status and with a non-zero exit status.
- The exit status of a series of commands is that of the last simple command executed.
- The exit status of a variable assignment alone is that of the last substituted command, or zero if there are no command substitutions.

```bash
! pipeline       # Negates the exit code of the whole pipeline. Being a 
                 # reserved word, it must be separated by a space. It 
                 # returns an exit status of 0 if the pipeline exited 
                 # non-zero, and an exit status of 1, if the pipeline 
                 # exited zero
cmd1 | cmd2      # Output of cmd1 is piped into cmd2
[n]> file        # Output from n is redirected to file, by default 
                 # n is 1 (stdout), in that case the 1 can be omitted
>/dev/null 2>&1  # 1 goes to null and 2 (stderr) goes to what 1 refers to 
                 # at this moment (that's null). The order of these two 
                 # redirections matters here 
[n]>> file       # Output from n appended to file 
                 # (n can be omitted if it is 1)
[n]< file        # Input from file into n, by default n is 0 (stdin), 
                 # in that case the 0 can be omitted
[n]<< ENDTXT     # Redirect into n from current script point until ENDTXT 
                 # $ ${..} $(..) $((..)) are interpreted
                 # (n can be omitted if it is 0)
[n]<< 'ENDTXT'   # Redirect into n from current script point until ENDTXT 
                 # $ ${..} $(..) $((..)) are NOT interpreted
                 # (n can be omitted if it is 0)
cmd1 && cmd2     # Execute cmd1. Then, if it exited with a zero exit status 
                 # (true), execute cmd2
cmd1 || cmd2     # Execute cmd1. Then, if it exited with a non-zero exit 
                 # status (false), execute cmd2
cmd1; cmd2       # Do cmd1 and then cmd2
cmd1 & cmd2      # Do cmd1, start cmd2 without waiting for cmd1 to finish
                 # (see Background commands)
{ cmds; }        # Group cmds, the last semicolon is required because cmds
                 # is a list, and the first curly bracket must be separated 
                 # by a space because it is a reserved word. Often used to 
                 # change precedence 
(cmds)           # Run cmds in a subshell, block until done. A subshell is a
                 # shell execution environment that gets a copy of local vars
                 # and functions (changes to the vars are not reflected back)
$(cmds)          # Command substitution runs cmds in a subshell, the output 
                 # replaces $(cmds). $(cmds) is supported in POSIX shells 
                 # and must be preferred over the obsolete `cmds` syntax 
                 # which has nesting problems 
                 # Note: trailing newlines are removed from command output 
```

**Precedence from highest to lowest**

1. Redirection operators
2. `|`
3. `&&  ||` (both carry equal precedence)
4. `;  &` (both carry equal precedence)

**Redirecting and piping binary data**

As long as the involved tools support binary data, it is safe to pipe or redirect binary data. For example `cat` and `split -b` are both binary capable.

**Signal 13 termination**

A signal 13 termination means that something is written to a pipe, but nothing is read. It often happens when a `head` command already got all the input it wants and closed its input pipe, while the source command is still writing into its output pipe. To hide the message, add `2>/dev/null` to the source command.


### Compound commands

Command groups, while loops or functions can be part of a pipeline or can also be redirected:

- The pipe operator is placed before the compound command or at the end on the same line as the terminator. In POSIX shells each compound command of a pipeline runs in a separate subshell. For example:  
  `cat file.txt | while read l; do printf '%s\n' "$l"; done`
- Redirections have to be placed at the end on the same line as the terminator. Each redirection is applied to all the commands within the compound command that do not explicitly override that redirection. For example:  
  `{ cmd1; cmd2; } > file.txt`


### Background commands

When executing a command the shell normally creates a new process and waits for it to finish. A command may be run without waiting for it to finish by appending a `&` like:

```bash
sleep 1000 &
```
 
A job is a process that the shell manages:

- `jobs` to see the running background jobs with their job number. 
- `fg %n` moves the job to foreground (re-started if stopped).
- `bg %n` re-starts a stopped background job.
- `Ctrl+Z` to put a running job into background stopping it.
- `kill %n` kills the given job.

Note: for background commands the stdin is detached (not for subshells). 


### wait

```bash
wait [PIDs]
```

- Without arguments it waits until all child processes terminate (wait exits with a zero exit status).
- If PIDs are given, it waits until all listed processes have terminate (wait exits with the exit status of the last listed PID).
 
Hint: `wait` only works for shell child processes, but it's possible to use `kill` to poll for the existence of an arbitrary process: `kill -0 $pid`


## Flow control

### if, while, until, for and case

- if-condition:
  
  ```bash
  if list then list elif list then list else list fi
  ```

  - `list` must be terminated by `;` or a newline.


- while-loop: 

  ```bash
  while list do list done
  ```

  - `list` must be terminated by `;` or a newline.
  - May contain `break` and `continue`


- until-loop (like while but test is inverted):
  
  ```bash
  until list do list done
  ```

  - `list` must be terminated by `;` or a newline.
  - May contain `break` and `continue`


- for-loop:

  ```bash
  for varname in words do list done
  ```
  
  - `words` and `list` must be terminated by `;` or a newline.
  - Short form of `for varname in "$@"` is `for varname`
  - May contain `break` and `continue`


- case-construct:

  ```bash
  case word in pattern | pattern ) list;; pattern | pattern ) list;; esac
  ```

  - `word` and `pattern` not subject to word splitting and pathname globbing.
  - `pattern` can contain unquoted globs used to match the given `word`


### null command

```bash
if who | grep -q jane
then
    :    # returns an exit status of 0
else
    echo "jane is not currently logged on"
fi
```

Note: both `:` and `true` return 0, for code clarity a good habit is to use `:` for empty commands and `true` in conditions.


### test

`[` and `test` are almost the same command, the only difference is that `[` expects its last argument to be `]`. As `[` is actually a command, it's necessary to add a space after `[` and also before `]` because that's the last argument of `[`.

Check files:

```bash
-r file         # check whether readable
-w file         # check whether writable
-x file         # check whether it can be executed
-f file         # check whether it's a regular file 
-s file         # check whether size greater than 0
-d file         # check whether it's a directory
-e file         # check existence (true even if file is a directory)
-t fd           # check whether file descriptor number is open and is 
                # associated with a terminal
```

Check strings:

```bash
"$var" = "str"  # check whether the same (space needed before/after =)
"$var" != "str" # check whether they differ (space needed before/after !=)
-z "$var"       # check whether var has size 0 (does not distinguish 
                # between an unset var and a var that is empty) 
-n "$var"       # check whether var has non-zero size
"$var"          # equivalent to -n "$var" 
```

Check numbers:

```bash
$num -eq 2      # check whether num equals 2
$num -ne 2      # check whether num is not equal to 2
$num -lt 2      # check whether num < 2
$num -le 2      # check whether num <= 2
$num -gt 2      # check whether num > 2
$num -ge 2      # check whether num >= 2
```

Negate and combine:

- To negate an expression use `!` (needs a space after it). It can also be placed outside the test command (pipeline negation).

- To combine expressions do not use the obsolete `-a` (and) and `-o` (or) options, instead use two tests combined with `&&` and `||`

- For grouping do not use test command's obsolete `\( \)`, instead implement multiple tests in braces like:

  ```bash
  [ -e file1 ] && { [ -x file2 ] || [ -x file3 ]; }
  ```


## Shell arithmetic

- In the original Bourne shell, arithmetic is done using the `expr` command:

  ```bash
  result=$(expr $var1 + 2)
  result=$(expr $var2 + $var1 / 2)
  result=$(expr $var2 \* 5)
  count=$(expr $count + 1)
  ```

- The POSIX shells have **arithmetic expansion** `$((..))` where specifying the variables with `$` or `${..}` is optional (exceptions are `$1`, `$2`, ... ):

  ```bash
  result=$((var1 + 2))
  result=$((var2 + var1 / 2))
  result=$((var2 * 5))
  count=$((count + 1))
  ```

- The above two methods only support integer operations, for floating-point we have the **basic calculator** command:

  ```bash
  var1=12.5
  var2=6.0
  echo "$var1 + $var2" | bc
  ```


## Functions

Function definitions must happen before their use and have the following format:

```bash
fname () compound-command
```

Examples on how to define and call functions:

```bash
myfunc1 () {
    provided_username=$1
    provided_password=$2
    return 2
}
myfunc1 "myusername" "mypassword"
if [ "$?" -eq "2" ]
then
    echo 'OK!'
fi

myfunc2 () { echo "Hi"; }
result=$(myfunc2)
echo $result
```

- Except for `$1`, `$2`, ... which contain the arguments passed to the function, all script variables can be read and written.
- Use `return [n]` to end the function, the returned value can be read with `$?`. The exit status of the last command is returned when no `return` is specified or when `n` is not given after `return`
- `echo` in function does write to stdout, that can be caught with `$(..)`


## Tilde expansion

```bash
~username/"path with space"
```

1. A word that begins with an unquoted tilde and an optional unquoted username will expand to the home directory. If a path follows, then also the first slash must be unquoted. If the username is invalid, or the tilde expansion fails, the word is left unchanged.
2. Tilde expansion happens in variable assignments.
3. The result of a parameter expansion is never tilde expanded (that's because tilde expansion happens before parameter expansion).
4. The pathname resulting from a tilde expansion is treated as if quoted to prevent it being altered by word splitting and pathname globbing.


## Pattern matching (globs or globbing)

Unquoted globs:

- `*` matches 0 or more characters.
- `foo*` matches any string beginning with `foo`
- `*x*` matches any string containing an `x` (begin, middle or end).
- `*.tar.gz` matches any string ending with `.tar.gz`
- `?` matches 1 character.
- `[AaBbCc]` matches 1 character from the list.
- `[!RGB]` matches 1 character not in the list.
- `[a-g]` matches 1 character from the range.
- `[CHARCLASS]` matches 1 character from the given [POSIX character class](#posix-character-classes), for examples: `[[:space:]]` or `[![:space:]]`

Pathname expansion has additional rules:

1. **Non-matching globs are expanded to themselves**, always `test` a match for existence with `-e`
2. Glob patterns do not match slashes and do not cross the slashes that separate pathname components.
3. Even if a filename contains spaces, tabs, newlines, quotes, the expansion of a glob that matches that filename will still preserve each filename as a single word.
4. Filenames beginning with a dot can only be matched by patterns that also start with a dot. To match dot files/directories excluding `.` and `..` use: `.[!.]* ..?*`
5. A glob that ends in `/` will only match directories, the `/` will be included in the result.

Important: always use `./*` instead of `*` so that filenames starting with a hyphen won't become options!


## Advanced

### Command available?

```bash
if command -v cmd >/dev/null 2>&1
then
    echo "cmd exists."
else
    echo "cmd not found."
fi
```


### eval

```bash
eval [args]
```

In simple terms with `eval` a given input is parsed twice. In detail, `eval` concatenates the arguments (which may have been expanded) with spaces, and then it instructs the shell to execute the result. The exit status of `eval` is the exit status of what has been run by the shell.


### dot command

```bash
. ./libraryname.sh
```

When a script is included with the dot command, it runs within the existing shell. Any variables created or modified by the script will remain available after it completes. In contrast, if a script is run normally, then a child shell (with a completely separate set of variables) is spawned to run the script. 

- Libraries should have a `.sh` extension and should not be executable. The Shebang is not necessary, but for syntax highlighting and for ShellCheck it's better to have it.

- In POSIX the dot command does not support passing arguments to the called script (pass them as variables).

- `source` is a synonym for the dot command in bash, but not in POSIX.


### exec

```bash
exec [cmd [args]] [redirections]
```

- If `cmd` is specified, `exec` replaces the shell with `cmd`, without creating a new process, thus the commands following the `exec` line will be ignored.

- If `cmd` is not specified, any redirections take effect in the current shell. The redirections can be used to open, close or copy a fd (file descriptor):

  ```bash
  exec 3< file    # open file as fd 3 for reading
  exec 4> file    # open file as fd 4 for writing
  exec 5<> file   # open file as fd 5 for reading/writing
  exec 6>> file   # open file as fd 6 for appending
  exec 7<&0       # duplicate stdin as fd 7
  exec 7<&-       # close fd 7 to free it for other processes to use
  ```


### trap

```bash
trap action signals
```

- `action`: 
  - A hyphen as an action resets each given signal to its default action.
  - A function as an action is called for the given signals.
  - Commands as an action are executed for the given signals:
    1. If the commands are placed in double-quotes all expansions will happen when the trap is defined.
    2. If the commands are placed in single-quotes all expansions will happen when the trap is executed.

- `signals` (space separated):
  - `INT` (2) sent when the user presses `Ctrl+C`
  - `TERM` (15) default kill signal (sent when you call `kill`).
  - `HUP` (1) hang up is sent when a user disconnects from the terminal, it has about the same harshness as `TERM`
  - `QUIT` (3) harshest of the ignorable signals.
  - `EXIT` (0) sent when the script exits at the end or with the exit command.
  - `KILL` (9) signal **cannot** be handled with a trap.

Attention: the default trap actions usually restore the tty to a sane state, but if you setup your own trap actions then you have to revert tty changes in them. 


## Manipulation

### Files

#### basename

```bash
basename 'path'
```

- Trailing slash is trimmed from the given path and then the rightmost part of that is printed.
- If path is `/` then `basename` returns `/`

#### dirname

```bash
dirname 'path'
```

- It's the complement of `basename`, it prints what `basename` does not print, but with the trailing slash trimmed.
- If path is `/` then `dirname` returns `/`

#### Make temporary file/directory

```bash
mktemp
```

- Makes a unique temporary filename and prints it to stdout. Usually it also gets created with size 0 (only some older systems do not create it), for example:  
  `mytempfile=$(mktemp)`
- The `-d` option creates a temporary directory instead of a file, for example:  
  `mytempdir=$(mktemp -d)`
- This command is not POSIX, but supported by most systems.

#### Truncate to zero length

```bash
: > 'path'
```


### Strings

#### Count characters

```bash
wc -m               # -c counts the bytes
str_length=${#var}  # some older shells return bytes instead of chars
```

#### Print numeric sequence

```bash
seq -s ', ' 1 10    # from 1 to 10 with given separator
```

#### Concatenate strings

```bash
ADDEDSTR=${var1}mytext'with space'"and $var2"
```

#### Test for substring

```bash
echo "$var" | grep -q "sub1"
```

#### Remove prefix/suffix strings

```bash
noprefix=${var#word}     # remove smallest prefix match
nosuffix=${var%word}     # remove smallest suffix match
noprefix=${var##word}    # remove largest prefix match
nosuffix=${var%%word}    # remove largest suffix match
```

- Hint: place `word` in quotes to prevent glob characters in it from being used to match the content of `var`

#### tr (operate on character sets)

```bash
echo "Str" | tr [a-z] [A-Z]     # lowercase to uppercase
echo "Str" | tr [:space:] '\t'  # any whitespace to a tab
echo "a{12}" | tr '{}' '()'     # transform braces into parentheses
printf 'N\nL\n' | tr -d '\n'    # delete all newlines
echo "Str" | tr -d 'St'         # delete a set of chars
echo "Str  Hi" | tr -s ' '      # squeeze chars leaving one occurrence
```


### Lines

#### Sort lines

```bash
sort
```

- `-n` numerically.
- `-u` suppress duplicated lines.
- `-r` reverse sort.

#### Count lines

```bash
wc -l
```

#### Show first N lines

```bash
head -n N
```

#### Show last N lines

```bash
tail -n N
```

#### Get N'th line

```bash
head -n N | tail -n 1
```

#### grep lines

```bash
grep 'regex' [filename]
```

- `-i` ignores case.
- `-w` matches whole words only.
- `-v` inverts the match (it hides the matching lines).
- `-E` for extended regular expression, for example if needing `+ ? |`  
  Note: `egrep` is obsolete, the `-E` option is the way to go.

#### Wrap lines

```bash
fold [filename]
```

- `-s` breaks at blank characters.
- `-w N` breaks at the given amount of column positions (default: 80).

#### Read input

```bash
read vars
```

- The `read` result (terminating newline removed) is field split to the given `vars` according to the IFS. If there are fewer fields than there are variables, the remaining variables are set to the empty string. If there are fewer variables than fields, the last variable will be set to the remaining fields with trailing IFS whitespaces removed.
- By default `read` will interpret backslashes as escape characters. This is rarely desired. Normally you just want to read data, including backslashes as part of the input string, that is what the `-r` option does.

#### User input

```bash
printf 'Do you want to continue (y/N) ? ' # capitalized answer in (y/N) 
read -r answer                            # is considered the default 
if [ "$answer" != "${answer#[Yy]}" ]      # when just ENTER is pressed 
then
    echo Yes
else
    echo No
fi
```

#### Read line by line

```bash
while IFS= read -r line || [ -n "$line" ]
do
    printf '%s\n' "$line"
done < "$filename"
```

- Clear IFS to prevent leading/trailing whitespaces from being trimmed.
- `read` always places the last line into the variable, but returns a nonzero status if no ending newline is found, thus `|| [ -n "$line" ]` is necessary to make sure that the last line is gotten.


### diff

```bash
diff left right
```

- `-C N` outputs N-lines of context output, `-c` is the short form for `-C 3`
- `-U N` outputs N-lines of unified context output, `-u` is the short form for `-U 3`
- Exit status of 0 if no differences found.

In the traditional output format (which is the default), the `<` and `>` signs indicate which file the lines appear in, `a` stands for added, `d` for deleted, `c` for changed, `L` is the left file line range and `R` is the right file line range:

1. `LaR` means add after line `L` the lines from `R` range.
2. `LcR` means change `L` range with `R` range.
3. `LdR` means delete `L` range (if not deleted they would have appeared after line `R`).

The traditional format is hard to read because we do not see the context around the changes. The context format shows the change hunks with some lines above and below. The unified format also shows the context, but the left and right changes are interleaved.

Note: traditional format and context format use `start-line,end-line` ranges, while the unified format uses `start-line,count` ranges.


### cut

```bash
cut -c LIST [filename]
cut -d DELIM -f LIST [filename]
```

- `DELIM` is a single character that splits the string (default is TAB), that same character is also used to separate the output fields.
- `LIST` is made up of one range, or many ranges separated by commas. Range: `N-M` (one-based and `N-` means `N` to end).
- `cut` always appends a newline at the end.

To remove the last char use the reverse tool:

```bash
echo 'Hello World!' | rev | cut -c 2- | rev 
```

- `rev` does not reverse the ending newline.
- `rev` does not append a newline if it is not present.


### awk

```bash
awk 'cond1{action1;action2}cond2{action3;action4}' input.txt
awk 'BEGIN {print "START"}'   # BEGIN is run before any records are read
awk 'END {print "STOP"}'      # END is run after the last record is read
awk '{print $1}'              # print first field
awk '{print $1 $3}'           # print fields 1 and 3 with no separation
awk '{print $1,$3}'           # print fields 1 and 3 separated by OFS
awk '{print $(NF-1),$NF}'     # print second last and last fields
awk '{print NR":"NF,$0}'      # record num and num of fields in record
awk '{print}'                 # print all with FS (same as print $0)
awk '{$1=$1; print}'          # print all with OFS
                              # ($1=$1 forces rebuilding the record)
awk '{action with no print}1' # 1 is true and default action is print
awk '{$2="new" OFS $2}1'      # insert a field in second position
awk '{$(NF+1)=$1+$2}1'        # append a field which is the sum $1+$2
awk '{for(i=3;i<NF;i++)printf "%s%s",$i,OFS;print $NF}' # fields range
awk 'NR>1 && NR<=3'           # records range
awk '(NR % 2) == 0'           # even records
```

- Fields are columns of data and records are rows of data; one-based indexing is used.
- `awk` strings must be enclosed in double-quotes, not in single-quotes (single-quotes have no special meaning in `awk`).
- `awk` concatenates strings, numbers or variables when placing them next to one another (sometimes a space may be required to distinguish them).
- Variables in `awk` are assigned like in shell, but used without the dollar sign. The dollar sign is to read/write the fields.
- Use multiple `-v` options to set `awk` variables.
- `-v FS=' '` **input field separator** can be a single character or an extended regular expression. The default is a single space which has a special meaning for `awk`: leading/trailing whitespaces are ignored and fields are separated at chains of contiguous whitespaces. If just a literal space is wished as separator, then it has to be specified as character class: `FS='[ ]'`. A multi-space/tab separator could be: `FS='[ ]{2,}|\t'`. For `FS=` the behavior is unspecified. `-F ' '` is an alias.
- `-v RS='\n'` **input record separator** must be a single character, default is a newline. If `FS` and `RS` are the same, `RS` wins, that's because `awk` needs to determine the record first, then it can break the record into fields. With `RS=` (paragraph mode) records are separated by one or more empty lines and leading/trailing empty lines are ignored.
- `-v OFS=' '` **output field separator** can be a string, default is a single space.
- `-v ORS='\n'` **output record separator** can be a string, default is a newline.


### sed

```bash
echo 'This is the OldString' | sed 'N,M s/OldString/NewString/g'
sed 's/OldString/NewString/g' input.txt
echo 'hi!' | sed 's/.$//'     # removes the last char
echo 'These are 12 34 2140' | sed 's/[0-9]/N/g'
echo 'hi  there!' | sed -E 's/([a-z]*)[[:space:]]+([a-z]*).*/\1 \2/g'
```

- `sed` reads one line at a time and if a trailing newline is present, it removes it. When `sed` is done, it re-adds the trailing newline, but only if it was already there.
- The character after `s` (substitute) defines the delimiter; conventionally it is a slash, but you can take whatever is not in your strings.
- Without `g` (global), `sed` only replaces the first occurrence on each line (leave the terminating slash because `sed` expects three delimiters).
- Line range: `N,M` (one-based and `N,$` means `N` to end).
- We can have any number of `&` (placeholder) in the replacement string.
- `\1..\9` are the placeholders for the `(..)` matches, use `-E` to not escape `(..)`
- `-i` edits given file in-place; sed has no case-insensitive matching option!!
- `-E` is for extended regular expression, for example if needing `+ ? |`

### POSIX character classes

Don't confuse the POSIX character class with what is normally called a "regex character class". `[x-z0-9]` is an example of a "regex character class" which POSIX calls a "bracket expression". `[:digit:]` is a **POSIX character class**, used inside a "bracket expression" like `[x-z[:digit:]]`

In regex use POSIX character classes like:

```bash
[[:space:]] instead of \s (space, tab, newline, carriage return)
[[:blank:]] space and tab
[[:word:]]  instead of \w or [a-zA-Z0-9_]
[[:alnum:]] instead of [a-zA-Z0-9]
[[:alpha:]] instead of [a-zA-Z]
[[:digit:]] instead of \d or [0-9]
[[:lower:]] instead of [a-z]
[[:upper:]] instead of [A-Z]
```


### getopts

According to POSIX, options are single alphanumeric characters preceded by a hyphen, they can have an optional option-argument following it separated by optional whitespaces. Multiple options may follow a hyphen if the options do not take option-arguments. After the options, non-option arguments, also called operands, may follow. `getopts` supports the POSIX guideline of explicitly marking the end of the options with the `--` delimiter. It is not mandatory to provide `--`, just make sure that the first non-option argument does not start with a hyphen. For example, if this first non-option argument is a glob, then there is a chance that the first expanded filename starts with a hyphen.  
Note: bear in mind that not all UNIX commands support the `--` convention.

```bash
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
```
