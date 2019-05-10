all: pdf fetch show

ssh:
	@vagrant ssh-config > ssh_config

pdf: ssh
	@ssh -F ssh_config root@default "cd ~pbuehler/BSDCan/2018 && make"

fetch:
	@scp -F ssh_config root@default:/home/pbuehler/BSDCan/2018/BSDCan-Puffalanche.{pdf,roff} .

show:
	@open -n ./BSDCan-Puffalanche.pdf
