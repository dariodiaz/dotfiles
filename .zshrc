# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="af-magic"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github mvn ruby sublime)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
########  ALIASES   #########
__has_parent_dir () {
    # Utility function so we can test for things like .git/.hg without firing
    # up a separate process
    test -d "$1" && return 0;

    current="."
    while [ ! "$current" -ef "$current/.." ]; do
        if [ -d "$current/$1" ]; then
            return 0;
        fi
        current="$current/..";
    done

    return 1;
}

__vcs_name() {
    if [ -d .svn ]; then
        echo "- [svn]";
    elif __has_parent_dir ".git"; then
        echo "- [git $(parse_git_branch)]";
    elif __has_parent_dir ".hg"; then
        echo "- [hg $(hg branch)]"
    fi
}

black=$(tput -Txterm setaf 0)
red=$(tput -Txterm setaf 1)
green=$(tput -Txterm setaf 2)
yellow=$(tput -Txterm setaf 3)
dk_blue=$(tput -Txterm setaf 4)
pink=$(tput -Txterm setaf 5)
lt_blue=$(tput -Txterm setaf 6)
bold=$(tput -Txterm bold)
reset=$(tput -Txterm sgr0)

#export PS1='\[$bold\]\[$black\][\[$dk_blue\]\@\[$black\]]-[\[$green\]\u\[$yellow\]@\[$green\]\h\[$black\]]-[\[$pink\]\w\[$black\]]\[\033[0;33m\]$(__vcs_name) \[\033[00m\]\[$reset\]\n\[$reset\]⚡ '

#export PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[$red\]-> \[\033[01;34m\]\w\[\033[0;33m\] $(__vcs_name) \[\033[00m\]\n⚡ '

alias ls='ls -F --color=always'
alias dir='dir -F --color=always'
alias ll='ls -l'
alias lld='ls -ltrF --color | grep ^d'
alias cp='cp -iv'
alias c='pygmentize -O style=monokai -f console256 -g'
#alias rm='rm -i'
alias mv='mv -iv'
alias grep='grep --color=auto -i'

alias ..='cd ..'

alias chmod_files='find -maxdepth 10 -type f -exec chmod 644 {} \;'
alias chmod_folders='find -maxdepth 10 -type d -exec chmod 755 {} \;'

process() {
    ps -ef | grep $1
}

apache() {
    sudo service apache2 $1
}

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && cd "$@"
}


# find shorthand
function f() {
    find . -name "$1"
}

# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}


# lets toss an image onto my server and pbcopy that bitch.
function scpp() {
    scp "$1" aurgasm@aurgasm.us:~/paulirish.com/i;
    echo "http://paulirish.com/i/$1" | pbcopy;
    echo "Copied to clipboard: http://paulirish.com/i/$1"
}


# Copy w/ progress
cp_p () {
  rsync -WavP --human-readable --progress $1 $2
}


# Test if HTTP compression (RFC 2616 + SDCH) is enabled for a given URL.
# Send a fake UA string for sites that sniff it instead of using the Accept-Encoding header. (Looking at you, ajax.googleapis.com!)
function httpcompression() {
    encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" | grep '^Content-Encoding:')" && echo "$1 is encoded using ${encoding#* }" || echo "$1 is not using any encoding"
}

# Syntax-highlight JSON strings or files
function json() {
    if [ -p /dev/stdin ]; then
        # piping, e.g. `echo '{"foo":42}' | json`
        python -mjson.tool | pygmentize -l javascript
    else
        # e.g. `json '{"foo":42}'`
        python -mjson.tool <<< "$*" | pygmentize -l javascript
    fi
}

# take this repo and copy it to somewhere else minus the .git stuff.
function gitexport(){
    mkdir -p "$1"
    git archive master | tar -x -C "$1"
}

# get gzipped size
function gz() {
    echo "orig size    (bytes): "
    cat "$1" | wc -c
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}

# All the dig info
function digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
    echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
    echo # newline
}

function extract()    # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
#-------------------------------------------------------------#
# --- Custom Aliases --- #

## a quick way to get out of current directory ##
alias ..='cd ..'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# Generate Sha digest
alias sha1='openssl sha1'

# install  colordiff package :)
alias diff='colordiff'

# Make mount command output pretty and human readable format
alias mount='mount |column -t'

# Command short cuts to save time #
alias h='history'
alias j='jobs -l'

# Create a new set of commands
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

#Control output of networking tool called ping
# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

# Show open ports
alias ports='netstat -tulanp'

# Control firewall (iptables) output
## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'

# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# Debug web server / cdn problems with curl
# get web server headers #
alias header='curl -I'

# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

# Update Debian Linux server
# install with apt-get
alias apt-get="sudo apt-get"
alias updatey="sudo apt-get --yes"
alias install="sudo aptitude install"

# update on one command
alias update='sudo apt-get update && sudo apt-get upgrade'

# Tune sudo and su
# become root #
alias root='sudo -i'
alias su='sudo -i'

# Pass halt/reboot via sudo
# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# Control web servers
# also pass it via sudo so whoever is admin can reload it without calling you #
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias apachereload='sudo /usr/sbin/apachectl -k graceful'
alias apachetest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'

# Set default interfaces for sys admin related commands
## All of our servers eth1 is connected to the Internets via vlan / router etc  ##
alias dnstop='dnstop -l 5  eth1'
alias vnstat='vnstat -i eth1'
alias iftop='iftop -i eth1'
alias tcpdump='tcpdump -i eth1'
alias ethtool='ethtool eth1'

# Get system memory, cpu usage, and gpu memory info quickly
## pass options to free ##
alias meminfo='free -m -l -t'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Get server cpu info ##
alias cpuinfo='lscpu'

## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

# Resume wget by default
## this one saved by butt so many times ##
alias wget='wget -c'

## set some other defaults ##
alias df='df -H'
alias du='du -sch'

# top is atop, just like vi is vim
alias top='htop'
alias selenium='java -jar $HOME/Programacion/selenium-server-standalone-2.25.0.jar'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias sniff="sudo ngrep -W byline -d 'eth1' -t '^(GET|POST) ' 'tcp and port 80'"

grepit(){
      find . -name "*${2}" -print | xargs grep -nir "${1}"
}

alias ifconfig-ext='curl ifconfig.me'
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias sniff2="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"

function mcd() {
  mkdir -p "$1" && cd "$1";
}

alias lf='ls -Gl | grep ^d' #Only list directories
alias lsd='ls -Gal | grep ^d' #Only list directories, including hidden ones
alias lg='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'''

ft() {
  find . -name "$2" -exec grep -il "$1" {} \;
}

alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Z script
. $HOME/z.sh

# Android SDK
export PATH=$PATH:$HOME/android-sdk-linux/

## RVM - This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
#[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Convertir ovg a avi
alias ogv2avi="sh $HOME/ogv2avi.sh"

# Laravel
# Crear un proyecto laravel
alias laravel="composer create-project laravel/laravel"

# Artisan linea de comandos
alias artisan="php artisan"

# PHP server
alias phps="php -S localhost:8000"

# Para mostrar la version de php en prompt
PHPBREW_SET_PROMPT=1

# PHP brew para manejar multiples versiones de php - como pyenv
source ~/.phpbrew/bashrc

# Alias para actualizar todos los repositorios git en un directorio
REPOS_DIRECTORY="/home/d4r1o/Programacion/Repos/"
alias update_repos="find . -maxdepth 1 -type d -print -execdir git --git-dir={}/.git --work-tree=$REPOS_DIRECTORY/{} pull origin master \;"

# Whenever you need to fetch your ssh-key, just type sshkey, and it'll be copied to your clipboard
function sshkey() { xclip -sel clip < ~/.ssh/"$@" && echo 'Copied to clipboard.' ;}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Alias to connect via ssh
alias stella="ssh stella"
alias ddiaz-rbm="ssh ddiaz-rbm"
alias d4r1o-laptop="ssh d4r1o-laptop"
