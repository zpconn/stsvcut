Tiny command line helper function that streams line-buffered TSV data from stdin, extracts desired fields from each line, and then streams their values to stdout. Targeted field names are specified as command line arguments. The output buffer is flushed after each input line is processed, so this is very composable with Unix pipes.

For instance:

```
> stsvcut a b
a	1	b	2
1	2
f	3	c	4	b	1
    1
```

