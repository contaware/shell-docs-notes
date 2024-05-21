# awk

The `awk` (abbreviation of the developers Aho, Weinberger and Kernighan) tool processes text files dividing them first in rows and then in columns.

An `awk` script is a series of condition-action pairs, where the condition is typically an expression and action is a sequence of commands. Either a condition or an action can be implied, an empty condition is considered true and a missing action defaults to print.

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
