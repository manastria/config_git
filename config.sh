git config --global user.name "votre pseudo"
git config --global user.email votre_email@votredomaine.com
git config --global color.ui true
git config --global http.sslVerify false
git config --global push.default simple
git config --global core.autocrlf false
git config --global core.safecrlf false
git config --global alias.hist "log --graph --decorate --format=format:'%C(dim red)%h%C(reset) | %C(bold green)%ad%C(reset) | %C(bold magenta)%d%C(reset) %C(reset)%s%C(reset) %C(bold blue)[%aN]%C(reset)' --date=short"
git config --global core.pager cat


# Pour windows
git config --global credential.helper wincred
git config --global core.longpaths true

# Pour un projet
git config core.fileMode false

