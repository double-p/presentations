# 
# we need pkg_add groff gpresent ghostscript-9.07p2-a4-no_x11 (and xbaseNN.tgz before)
ROFF=AsiaBSDCon2017-smtf.roff

all: pdf

pdf:
	@echo "input: ${ROFF}"
	@echo "generate pps"
	@groff -mm -mpresent ${ROFF} > asiabsdcon2017-talk.pps 2>/dev/null
	@echo "generate ps"
	@presentps -l asiabsdcon2017-talk.pps > asiabsdcon2017-talk.ps  2>/dev/null
	@echo "generate pdf"
	@ps2pdf asiabsdcon2017-talk.ps >/dev/null 2>&1
