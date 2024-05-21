# diff

`diff` is a line-oriented tool which displays the differences between the contents of two files. 

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
