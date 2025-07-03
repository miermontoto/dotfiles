abbr --erase (abbr --list)

# git
abbr -a !gs 'g status' # needs gitfox installed → sudo npm i -g gitfox
abbr -a gac 'git add -A :/ && git commit -m'
abbr -a ga 'git add .'
abbr -a gs 'git status'
abbr -a gd 'git diff'
abbr -a branch 'git checkout'
abbr -a gp 'git push'
abbr -a gpl 'git pull'
abbr -a gcl 'git clone'
abbr -a gc 'git commit -m'
abbr -a gclmm 'git clone https://github.com/miermontoto/'
abbr -a gf 'git fetch --all --prune'

# dnf
abbr -a 'i' 'sudo dnf install'
abbr -a 'r' 'sudo dnf remove'
abbr -a 'u' 'sudo dnf update; sudo flatpak upgrade -y'

# config files
abbr -a 'config.fish' 'zed ~/dotfiles/.config/fish/config.fish'
abbr -a 'alacritty.yml' 'zed ~/dotfiles/.config/alacritty/alacritty.toml'
abbr -a 'alacritty.toml' 'zed ~/dotfiles/.config/alacritty/alacritty.toml'
abbr -a 'abbr.fish' 'zed ~/dotfiles/.config/fish/conf.d/abbr.fish'
abbr -a 'starship.toml' 'zed ~/dotfiles/.config/starship.toml'
abbr -a 'config.ssh' 'zed ~/dotfiles/.ssh/config'
abbr -a 'okt.ssh' 'zed ~/dotfiles/.ssh/okt/config'
abbr -a 'config.kdl' 'zed ~/dotfiles/.config/zellij/config.kdl'
abbr -a 'layout.kdl' 'zed ~/dotfiles/.config/zellij/layout.kdl'

# aliases
abbr -a powershell 'pwsh'
abbr -a pt 'sudo powertop'
abbr -a nf 'neofetch'
abbr -a ff 'fastfetch'
abbr -a vscode 'code'
abbr -a cls 'clear'
abbr -a bios 'systemctl reboot --firmware-setup'
abbr -a windows 'systemctl reboot --firmware-setup'
abbr -a activate 'source env/bin/activate.fish'
abbr -a ls 'eza -1'
abbr -a cat 'bat'
abbr -a pn 'pnpm'
abbr -a lg 'lazygit'
abbr -a mip 'curl https://am.i.mullvad.net'
abbr -a spice 'sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps && sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify && spicetify update && flatpak run com.spotify.Client'

# docker
abbr -a 'dka' 'docker kill $(docker ps -q)'
abbr -a 'dsa' 'service docker start'
abbr -a 'dso' 'service docker stop'
abbr -a 'dps' 'docker ps'

# okt
abbr -a ossh 'sh ~/okt/okt-scripts/okts.sh'

## okt-api
abbr -a api 'docker exec -it okticket-api'
abbr -a pu 'docker exec -it okticket-api vendor/bin/phpunit'
abbr -a puf 'docker exec -it okticket-api vendor/bin/phpunit --stop-on-failure --stop-on-error'
abbr -a du 'docker exec -it okticket-api bash -c "composer du -o --quiet && php artisan config:clear && php artisan cache:clear && php artisan config:cache && php artisan route:cache"'
abbr -a cud 'docker exec -it okticket-api bash -c "php -d memory_limit=-1 /usr/bin/composer update"'
abbr -a cin 'docker exec -it okticket-api bash -c "php -d memory_limit=-1 /usr/bin/composer install"'
abbr -a wipe 'docker exec okticket-db-mysql mysql -uroot -pokticket -e "DROP DATABASE IF EXISTS admin_okt; CREATE DATABASE admin_okt;" && docker exec okticket-db-mongodb mongo -u admin -p okticket --authenticationDatabase admin --eval "db.getSiblingDB(\'okticket\').dropDatabase()"'
abbr -a val 'docker exec -it okticket-api bash -c "php artisan optimize; vendor/bin/phpunit --stop-on-failure --stop-on-error --filter BulkImport > /dev/null 2>&1; vendor/bin/phpunit --stop-on-failure --stop-on-error"'
abbr -a tpuf 'docker exec -it okticket-api vendor/bin/phpunit --stop-on-failure --stop-on-error; vendor/bin/phpunit --stop-on-failure --stop-on-error'
abbr -a seed 'docker exec -it okticket-api php artisan db:seed --class='
abbr -a mig 'docker exec -it okticket-api php artisan migrate'
abbr -a artisan 'docker exec -it okticket-api php artisan'
abbr -a ov 'ruby ~/okt/okt-scripts/oktVolumes.rb'
abbr -a queue 'docker exec -it okticket-api php artisan queue:work -vvv --queue=notifications,default'
abbr -a rf 'ruby docker-compose/scripts/route_finder.rb'
abbr -a ab 'ruby docker-compose/scripts/builder.rb'
abbr -a routes 'docker exec -it okticket-api php artisan route:list'

abbr -a slo 'pnpm serverless:offline'
abbr -a sld 'pnpm serverless:deploy'
abbr -a slt 'pnpm run:test'
