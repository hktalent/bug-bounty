cat $HOME/Downloads/shodan.html|grep -Eo '(https://[^"]+)'|xargs -I % wget -c "%"

