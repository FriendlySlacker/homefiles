alias ll="ls -alh"
alias cl="clear"
alias screenfetch='bash /etc/screenfetch.sh'
alias proxychains='/usr/local/bin/./proxychains4 -f /etc/proxychains.conf'
alias unmute='amixer set -c 0 Master 100 unmute'
alias notes='python ~/notes.py'
alias pipes='bash /etc/pipes.sh'
alias screencast='bash ~/screencast.sh'
alias colors='python /etc/colors.py'
alias rnb='toilet -F border -f future -F gay'
alias weechat='exec /usr/bin/weechat/bin/weechat'
alias rallyx='bash /etc/rallyx.sh'
alias skull='bash /etc/skull.sh'
alias scheme='bash /etc/scheme.sh'
#enable 256-color mode
export TERM='rxvt-256color'
export PS1="\[$(tput setaf 7)\]┌─╼ \[$(tput setaf 5)\][\w]\n\[$(tput setaf 7)\]\$(if [[ \$? == 0 ]]; then echo \"\[$(tput setaf 7)\]└────╼\"; else echo \"\[$(tput setaf 7)\]└╼\"; fi) \[$(tput setaf 12)\]"
alias mpdviz='exec /usr/bin/mpdviz'
PATH=$PATH=/sbin
export PATH=$PATH=/sbin

