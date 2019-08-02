USER=pbuehler
EVENT=EuroBSDcon
TIME=2019
TALK=packer-openbsd

all: pdf fetch show
full: ssh pdf fetch show

ssh:
	@vagrant ssh-config > ssh_config

pdf:
	@ssh -F ssh_config root@openbsd-presenter \
		"cd /home/${USER}/presentations/${EVENT}/${TIME} && \
		make -f makefile.vm TALK=${TALK}"

fetch:
	@scp -F ssh_config \
		root@openbsd-presenter:/home/${USER}/presentations/${EVENT}/${TIME}/${TALK}.{roff,pdf} .

show:
	@open -n ./${TALK}.pdf
