# .dotfiles

This repository contains my .dotfiles for most of the application I am using. My goal is to follow as much possible the [XDG Base Directory specification](https://wiki.archlinux.org/title/XDG_Base_Directory) but in a pragmatic way. I recommend no one to use those dot files as they are but can be good for inspiration purposes.

## Concerned applications

- [bash](https://www.gnu.org/software/bash/)
- [cookiecutter](https://github.com/cookiecutter/cookiecutter)
- [ctags](https://github.com/universal-ctags/ctags)
- [emacs](https://www.gnu.org/software/emacs/)
- [dunst](https://dunst-project.org/)
- [git](https://git-scm.com)
- [ranger](https://github.com/ranger/ranger)
- [tmux](https://github.com/tmux/tmux/wiki)
- [vim](https://www.vim.org/docs.php)
- [zathura](https://pwmt.org/projects/zathura/documentation/)

## Deployment

- Clone as a repo
```bash
$ git clone --bare --recurse-submodules "git@github.com:RobinCamarasa/.dotfiles.git" "${HOME}/.dotfiles.git"
```
- Create the dotfile alias
```bash
$ alias dotfiles='/usr/bin/git --git-dir="${HOME}/.dotfiles.git/" --work-tree="${HOME}"'
```
- Deploy
```bash
$ dotfiles checkout && dotfiles submodule update && dotfiles config --local status.showUntrackedFiles no
```
- (Optional but recommended) Add your the dotfiles alias in `~/.bash_aliases`

## Contributor

[RobinCamarasa](https://RobinCamarasa.github.io)

