# xargs

xargs reads from the standard input to provide arguments to the given command. 

Input arguments are separated by blanks (space or tab) or newlines:

1. Quoted or backslash-escaped blanks are taken literally. 
2. Quotes can never span multiple lines, the only way to have literal newlines is to backslash-escape them.
3. If quotes have to be taken literally, then they must be backslash-escaped or within the other quote type.

xargs does not exceed the system's `ARG_MAX` limit, if necessary, it calls the given command multiple times until all input arguments are processed. 

```bash
<input arguments> | xargs [options] command
```

- `-t` prints the resulting command and execute it.
- `-p` prompts for confirmation before executing the command (the command is shown by the prompt, no need for `-t`).
- `-n NUM` sets the maximum number of input arguments per executed command.
- `-L NUM` executes the command passing it all the arguments of the given number of lines.
- `-I PLACEHOLDER` replaces every occurrence of the `PLACEHOLDER` string with an input argument. This option forces the number of arguments per executed command to 1 (like option `-n 1`). The arguments from the standard input must be separated by newlines (unless the non-POSIX `-0` option is specified, in which case the arguments must be separated by `\0`). To reflect the `find -exec` syntax, the `PLACEHOLDER` is often chosen to be `{}`.

UNIX filenames may contain any character except for slash and `\0`. For xargs to work safely, the pathnames cannot contain special chars like spaces or newlines. Pathnames having only spaces as special chars, can be processed with the `-I` option. Many systems provide safe non-POSIX tools using the `\0` as a separator (`xargs -0` and `find -print0`). But most of the time xargs is not necessary, `find -exec` does the job well.
