all: pdf fetch show

ssh:
	@vagrant ssh-config > ssh_config

pdf: ssh
	@#ssh -F ssh_config root@default "cd ~pbuehler/EuroBSDcon/2016 && make ; cd tutorial && make"
	@ssh -F ssh_config root@default "cd ~pbuehler/EuroBSDcon/2016 && make"

fetch: ssh
	@#scp -F ssh_config root@default:/home/pbuehler/EuroBSDcon/2016/{tutorial,}/eurobsdcon2016-talk.pdf .
	@scp -F ssh_config root@default:/home/pbuehler/EuroBSDcon/2016/eurobsdcon2016-talk.pdf .
	@scp -F ssh_config root@default:/home/pbuehler/EuroBSDcon/2016/EuroBSDcon*.roff .

show:
	@open ./eurobsdcon2016-talk.pdf
