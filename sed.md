# sed

`sed` (**s**tream **ed**itor) has several commands, but the most used one is the substitute command which changes the regular expression occurrences into new values. The character after `s` (substitute) defines the delimiter; conventionally it is a slash, but you can take whatever is not in your strings.

`sed` reads one line at a time and if a trailing newline is present, it removes it. When it is done, it re-adds the trailing newline, but only if it was already there.

```bash
echo 'This is the OldString' | sed 'N,M s/OldString/NewString/g'
sed 's/OldString/NewString/g' input.txt
echo 'hi!' | sed 's/.$//'     # removes the last char
echo 'These are 12 34 2140' | sed 's/[0-9]/N/g'
echo 'hi  there!' | sed -E 's/([a-z]*)[[:space:]]+([a-z]*).*/\1 \2/g'
```

- Without `g` (global), `sed` only replaces the first occurrence on each line (leave the terminating slash because `sed` expects three delimiters).
- Line range: `N,M` (one-based and `N,$` means `N` to end).
- We can have any number of `&` (placeholder) in the replacement string.
- `\1..\9` are the placeholders for the `(..)` matches, use `-E` to not escape `(..)`
- `-i` edits given file in-place; `sed` **has no case-insensitive matching option!!**
- `-E` is for extended regular expression, for example if needing `+ ? |`
