# History search with Arrow Keys

`.inputrc` in your Home directory.

`~/.inputrc`

```bash
# Respect default shortcuts.
$include /etc/inputrc

## arrow up
"\e[A":history-search-backward
## arrow down
"\e[B":history-search-forward
```