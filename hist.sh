#!/bin/sh

git config --global alias.hist "log --graph --decorate --format=format:'%C(dim red)%h%C(reset) | %C(bold green)%ad%C(reset) | %C(bold magenta)%d%C(reset) %C(reset)%s%C(reset) %C(bold blue)[%aN]%C(reset)' --date=short"
