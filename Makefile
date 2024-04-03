.PHONY: compile publish check fix lint fixlint format mypy deadcode audit test

check: test lint mypy audit deadcode
fix: fixlint format
venv: .venv

.venv:
	pip install uv
	uv venv -p 3.11
	uv pip sync requirements-dev.txt
	uv pip install -e .[test]

sync: venv
	@echo "Upgrading installed dependencies in Virtual Environment"
	uv pip sync requirements-dev.txt
	uv pip install -e .[test]

compile:
	@echo "Bumping dependency versions in requirements*.txt files"
	# uv pip compile -U -q pyproject.toml -o requirements.txt
	# uv pip compile -U -q --all-extras pyproject.toml -o requirements-dev.txt
	uv pip compile -U -q pyproject.toml -o requirements.txt
	uv pip compile -U -q --all-extras pyproject.toml -o requirements-dev.txt

publish: venv
	rm -fr dist/*
	.venv/bin/hatch build
	.venv/bin/hatch -v publish

lint: venv
	.venv/bin/ruff check whattoread tests

fixlint: venv
	.venv/bin/ruff --fix whattoread tests
	.venv/bin/deadcode --fix whattoread tests

format: venv
	.venv/bin/ruff format whattoread tests

mypy: venv
	.venv/bin/mypy whattoread

audit: venv
	.venv/bin/pip-audit

deadcode: venv
	.venv/bin/deadcode whattoread tests

test: venv
	.venv/bin/pytest $(PYTEST_ME_PLEASE)
