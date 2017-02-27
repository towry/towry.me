
all:
	hugo server -w

publish:
	bash ./bundle/publish.sh

.PHONY: publish
