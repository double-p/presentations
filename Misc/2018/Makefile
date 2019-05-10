all: pdf fetch show

ssh:
	@vagrant ssh-config > ssh_config

pdf: ssh
	@ssh -F ssh_config root@default "cd ~pbuehler/AsiaBSDCon/2018 && make"

fetch:
	@scp -F ssh_config root@default:/home/pbuehler/AsiaBSDCon/2018/bhyveCon-WIP.{pdf,roff} .

show:
	@open -n ./bhyveCon-WIP.pdf
