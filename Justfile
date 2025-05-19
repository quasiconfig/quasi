set dotenv-load
set unstable
set shell := ["zsh", "-cu"]

# ================================================================================================ #
# Project Configration Helpers

project_path := justfile_directory()

# Auto-Generated Paths
dir_build   := project_path/"target"

# Important Project Paths
dir_scripts := project_path/"scripts"

# ================================================================================================ #
# Project Info

# Output usage and helpful command info for the project
help:
    @just --list --alias-style=separate --justfile {{justfile()}}
_default: help

# Display information relevant to this system
@info: 
    echo "{{BOLD}}Architecture:{{NORMAL}} {{arch()}}"
    echo "{{BOLD}}OS:{{NORMAL}} {{os()}}"
    echo "{{BOLD}}OS Family:{{NORMAL}} {{os_family()}}"
    echo $'{{BOLD}}Rust Versions:{{NORMAL}}'
    echo "    $(rustc --version)"
    echo "    $(cargo --version)"
    echo "    $(cargo fmt --version)" 
    echo "    $(cargo clippy --version)"

# ================================================================================================ #
# Tooling

# Lints the source code, config files, and docs
@lint:
    cargo clippy --all-targets --all-features -- -D warnings
    yamllint -c ./.config/yamllint.yml .
    markdownlint-cli2 --config ./.config/.markdownlint.yml .

# Formats the source code by running all format-* recipes
@format:
    cargo fmt --all -- --check

# Run all tests
@test:
    cargo test

# Cleans frequently auto-generated files and directories (e.g. target)
clean:
    rm -r {{dir_build}}

# Cleans all auto-generated files and directories (e.g. docs, lockfile)
nuke: clean
    rm {{project_path}}/Cargo.lock

# ================================================================================================ #
# Building & Running

# Builds the local package for release
build:
    cargo build --release --all-targets --all-features

# Cleans and builds the local package for release
rebuild: clean build

# Runs the main binary of the local package
run:
    cargo run

# ================================================================================================ #

