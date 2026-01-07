# Root Makefile that exposes the AI sync target
.PHONY: sync-ai

include ai.mk

sync-ai:
	@$(MAKE) -f ai.mk sync-ai