all: none

img:
	@cd images && for fmt in .jpg .gif; do for img in *$${fmt} ; do sam2p $$img $$(basename $${img} $${fmt}).eps ; done ; done
none:
	@echo nope
