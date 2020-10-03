BASE_BOXES	= centos8-basebox
BOXES		= $(BASE_BOXES) centos8-ansible centos8-devbox centos8-oracle19c
TARGETS		= $(foreach box, $(BOXES), builds/virtualbox-$(box).box)

.PHONY: default
default: centos8-basebox.add

.PHONY: all
all: boxes add

.PHONY: boxes
boxes: $(TARGETS)

.PHONY: basebox
basebox: $(foreach box, $(BASE_BOXES), builds/virtualbox-$(box).box)

builds/virtualbox-%.box: templates/%.json
	packer build -force $<

$(foreach box, $(BASE_BOXES), builds/virtualbox-$(box).box): \
builds/virtualbox-%.box: http/%.ks scripts/basebox/*.sh

builds/virtualbox-%-ansible.box: scripts/ansible/*.sh builds/virtualbox-%-basebox.box
builds/virtualbox-%-devbox.box: builds/virtualbox-%-ansible.box
builds/virtualbox-%-oracle19c.box: scripts/oracle/* builds/virtualbox-%-basebox.box

.PHONY: add
add: $(BOXES:=.add)

.PHONY: $(BOXES:=.add)
$(BOXES:=.add): %.add: builds/virtualbox-%.box
	vagrant box add -f --name $* $<

.PHONY: remove
remove: $(BOXES:=.remove)

.PHONY: $(BOXES:=.remove)
$(BOXES:=.remove): %.remove:
	-vagrant box remove -f $*

.PHONY: list
list:
	vagrant box list

.PHONY: clean
clean:
	-rm -r output-virtualbox*
	-rm -r builds

.PHONY: clobber
clobber: clean
	-rm -r packer_cache

.PHONY: help
help:
	@echo "Targets:"
	@echo "all:     build all boxes and add to vagrant"
	@echo "boxes:   build all boxes"
	@echo "basebox: build mimimal base boxes"
	@echo "add:     add boxes to vagrant"
	@echo "remove:  remove boxes from vagrant"
	@echo "list:    list vagrant boxes"
	@echo "clean:   remove generated boxes"
	@echo "clobber: remove generated boxes and caches"
