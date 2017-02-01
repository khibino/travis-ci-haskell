

all: check

check:
	for s in travis-CI/*/*.sh ; do sh -n $$s ; done
