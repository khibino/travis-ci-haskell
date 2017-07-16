
all: check

check:
	for s in custom-cabal dirs.list sh-lib ; do sh -n travis-CI/$$s ; done
	for s in travis-CI/*/*.sh ; do sh -n $$s ; done
