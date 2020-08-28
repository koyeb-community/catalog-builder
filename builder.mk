NAME := $(shell cat koyeb.yaml | yq r - functions[0].name)
SCRIPT_DIR ?= .
TAGS ?=

build:
	$(SCRIPT_DIR)/package.sh $(NAME)

publish:
	docker push koyeb/$(NAME)
	for tag in $(TAGS) ; \
	do \
		docker tag koyeb/$(NAME) koyeb/$(NAME):$$tag ; \
		docker push koyeb/$(NAME):$$tag ; \
	done ;\
