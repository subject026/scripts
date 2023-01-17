# Linux Scripts

Currently can run init stackscript when droplet is created but update / upgrade command hangs unless user is present to confirm dialogs so do this manually.

Best to ssh in as root and run from there

```sh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/subject026/scripts/main/allInOne.sh)"
```

## todos

add to stackscript

1. disable root login
2. enable firewall
