.PHONY: help

help:
	@echo "🛠️ Commands:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

render-chart-%: ## Render a helm chart
	@helm template test ./charts/* --values ./charts/*/values.yaml --debug > _resoureces.yaml
