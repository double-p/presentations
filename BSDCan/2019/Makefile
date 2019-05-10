USER=pbuehler
EVENT=BSDCan
TIME=2019
TALK=packer-openbsd

all: ssh pdf fetch show
quick: pdf fetch show

ssh:
	@vagrant ssh-config > ssh_config

pdf:
	@ssh -F ssh_config root@openbsd-presenter \
		"cd /home/${USER}/presentations/${EVENT}/${TIME} && \
		make -f makefile.vm TALK=${TALK}"

fetch:
	@scp -F ssh_config \
		root@openbsd-presenter:/home/${USER}/presentations/${EVENT}/${TIME}/${TALK}.pdf .

show:
	@open -n ./${TALK}.pdf
