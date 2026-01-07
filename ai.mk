# AI sync Makefile (consumer-facing example)
include config/default-ai-config.mk

AI_BUILD_DIR := .ai-temp
AI_DEST_DIR := .github
AI_INSTRUCTIONS_FILE := $(AI_DEST_DIR)/copilot-instructions.md
AI_AGENTS_FILE := AGENTS.md
AI_SKILLS_DEST := $(AI_DEST_DIR)/skills

.PHONY: sync-ai clean-ai

sync-ai: clean-ai fetch-ai-repo build-instructions build-agents install-skills cleanup-ai
	@echo "✅ AI Context synchronization complete."

fetch-ai-repo:
	@echo "⬇️  Fetching AI Knowledge from $(AI_REPO_URL)..."
	@mkdir -p $(AI_BUILD_DIR)
	@cd $(AI_BUILD_DIR) && git init && git remote add origin $(AI_REPO_URL) && git config core.sparseCheckout true
	@echo "$(AI_INSTRUCTION_MODULES)" | tr ' ' '\n' > $(AI_BUILD_DIR)/.git/info/sparse-checkout || true
	@echo "$(AI_AGENT_PERSONA)" >> $(AI_BUILD_DIR)/.git/info/sparse-checkout || true
	@echo "$(AI_SKILLS)" | tr ' ' '\n' >> $(AI_BUILD_DIR)/.git/info/sparse-checkout || true
	@cd $(AI_BUILD_DIR) && git pull --depth=1 origin $(AI_REPO_REF) || true

build-instructions:
	@echo "🔨 Assembling $(AI_INSTRUCTIONS_FILE)..."
	@mkdir -p $(AI_DEST_DIR)
	@> $(AI_INSTRUCTIONS_FILE)
	@for module in $(AI_INSTRUCTION_MODULES); do \
		if [ -f "$(AI_BUILD_DIR)/$$module" ]; then \
			echo "---" >> $(AI_INSTRUCTIONS_FILE); \
			echo "### Module: $$module" >> $(AI_INSTRUCTIONS_FILE); \
			cat "$(AI_BUILD_DIR)/$$module" >> $(AI_INSTRUCTIONS_FILE); \
			echo "" >> $(AI_INSTRUCTIONS_FILE); \
		else \
			echo "⚠️  Warning: Module $$module not found in upstream."; \
		fi; \
	done

build-agents:
	@echo "🤖 Configuring Agent Persona..."
	@if [ -f "$(AI_BUILD_DIR)/$(AI_AGENT_PERSONA)" ]; then \
		cp "$(AI_BUILD_DIR)/$(AI_AGENT_PERSONA)" $(AI_AGENTS_FILE); \
	else \
		echo "⚠️  Warning: Agent persona $(AI_AGENT_PERSONA) not found."; \
	fi

install-skills:
	@echo "🧠 Installing Skills..."
	@mkdir -p $(AI_SKILLS_DEST)
	@for skill in $(AI_SKILLS); do \
		skill_name=$$(basename $$skill); \
		if [ -d "$(AI_BUILD_DIR)/$$skill" ]; then \
			echo "   -> Installing $$skill_name"; \
			rm -rf $(AI_SKILLS_DEST)/$$skill_name; \
			cp -r "$(AI_BUILD_DIR)/$$skill" $(AI_SKILLS_DEST)/; \
		fi; \
	done

cleanup-ai:
	@rm -rf $(AI_BUILD_DIR)

clean-ai:
	@rm -rf $(AI_BUILD_DIR)
