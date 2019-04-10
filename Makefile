BASE_BOXES	= centos7-basebox
BOXES		= $(BASE_BOXES) centos7-ansible centos7-puppet centos7-oracle12c centos7-weblogic12c
TARGETS		= $(foreach box, $(BOXES), builds/virtualbox-$(box).box)

.PHONY: default
default: centos7-basebox.add

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

builds/virtualbox-%-puppet.box: scripts/puppet/*.sh builds/virtualbox-%.box
builds/virtualbox-%-oracle12c.box: scripts/oracle/* builds/virtualbox-%.box

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
