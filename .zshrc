# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="smt"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git battery debian cp dircycle github themes urltools svn gitfast gnu-utils extract git-extras history ssh-agent )


# ant apache2-macports archlinux autojump battery brew bundler bwana cake capistrano cloudapp
# coffee colemak command-not-found compleat composer cp cpanm debian dircycle dirpersist django
# encode64 extract fasd forklift gas gem git git-extras gitfast git-flow github git-hubflow
# git-remote-branch gnu-utils gpg-agent gradle grails heroku history history-substring-search jake-node
# jira jruby kate knife laravel last-working-dir lein lighthouse lol macports mercurial mvn mysql-macports
# nanoc node npm nyan osx pass per-directory-history perl phing pip pj pow powder python rails rails3
# rake rbenv rbfu redis-cli rsync ruby rvm screen sprunge ssh-agent sublime supervisor suse svn symfony
# symfony2 systemd taskwarrior terminalapp terminitor textmate themes thor urltools vagrant vi-mode
# virtualenvwrapper vundle wakeonlan yum zeus zsh-syntax-highlighting

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

eval `dircolors ~/build/dircolors-solarized/dircolors.256dark`
DEFAULT_USER="victor"
