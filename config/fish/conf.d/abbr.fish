# ssh
abbr -a pi 'ssh pi@ssh.mier.info -i ~/.ssh/id_rsa_pi'
abbr -a server 'ssh server@192.168.0.88'
abbr -a lpi 'ssh pi@192.168.0.2'
abbr -a apd 'ssh mier@192.168.0.10'

# git
abbr -a !gs 'g status' # needs gitfox installed
abbr -a gac 'git add -A :/ && git commit -m'
abbr -a gd 'git diff'
abbr -a branch 'git checkout'
abbr -a gp 'git push'
abbr -a gpl 'git pull'
abbr -a gcl 'git clone'
abbr -a gc 'git commit'
abbr -a gclmm 'git clone https://github.com/miermontoto/'

# dnf
abbr -a 'install' 'sudo dnf install'
abbr -a 'i' 'sudo dnf install'
abbr -a 'remove' 'sudo dnf remove'
abbr -a 'r' 'sudo dnf remove'
abbr -a 'update' 'sudo dnf update; sudo flatpak upgrade -y'

# config files
abbr -a 'config.fish' 'nano ~/.config/fish/config.fish'
abbr -a 'alacritty.yml' 'nano ~/.config/alacritty/alacritty.yml'
abbr -a 'abbr.fish' 'nano ~/.config/fish/conf.d/abbr.fish'

# aliases
abbr -a 'powershell' 'pwsh'
abbr -a 'pt' 'sudo powertop'
abbr -a nf 'neofetch'
abbr -a vscode 'code'
abbr -a 'ls' 'exa'
abbr -a 'cls' 'clear'
abbr -a bios 'systemctl reboot --firmware-setup'
abbr -a windows 'systemctl reboot --firmware-setup'
abbr -a activate 'source env/bin/activate.fish'

# npm
abbr -a 'deploy' 'npm run deploy'
abbr -a 'build' 'npm run build'

# envycontrol
abbr -a 'integrated' 'sudo envycontrol -s integrated'
abbr -a 'hybrid' 'sudo envycontrol -s hybrid'
abbr -a 'nvidia' 'sudo envycontrol -s nvidia'

# launchers
abbr -a 'weka' 'sh ~/uo/y3t2/Inteligentes/PL/weka/weka.sh &'
abbr -a 'jmt' 'java -jar ~/uo/y3t1/CES/PL/JMT/jmt-mod-uniov-v4.jar'
abbr -a 'epi' 'python ~/git/epiCalendar/epiCalendar.py'
