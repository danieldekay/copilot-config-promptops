#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$SCRIPT_DIR"

usage() {
    cat <<'EOF'
Usage:
  ./install-github-links.sh install <repo-root-or-.github-path>
  ./install-github-links.sh uninstall <repo-root-or-.github-path>

Examples:
  ./install-github-links.sh install /path/to/repo
  ./install-github-links.sh install /path/to/repo/.github
  ./install-github-links.sh uninstall /path/to/repo

This script manages symlinks for these v2 directories:
  - agents/        -> .github/agents/
  - instructions/  -> .github/instructions/
  - skills/        -> .github/skills/
  - manifest.yaml  -> .github/deep-research-v2/manifest.yaml

Only symlinks pointing back to this v2 package are removed during uninstall.
EOF
}

resolve_github_dir() {
    local target_path="$1"
    local normalized

    normalized="$(cd "$target_path" 2>/dev/null && pwd || true)"
    if [[ -z "$normalized" ]]; then
        echo "ERROR: Target path not found: $target_path" >&2
        exit 1
    fi

    if [[ "$(basename "$normalized")" == ".github" ]]; then
        printf '%s\n' "$normalized"
    else
        printf '%s/.github\n' "$normalized"
    fi
}

link_file() {
    local source_file="$1"
    local github_dir="$2"
    local relative_path
    local destination
    local destination_dir

    relative_path="${source_file#"$PACKAGE_ROOT"/}"
    destination="$github_dir/$relative_path"
    destination_dir="$(dirname "$destination")"

    mkdir -p "$destination_dir"
    ln -sfn "$source_file" "$destination"
    echo "linked   $destination"
}

unlink_file() {
    local source_file="$1"
    local github_dir="$2"
    local relative_path
    local destination
    local destination_target

    relative_path="${source_file#"$PACKAGE_ROOT"/}"
    destination="$github_dir/$relative_path"

    if [[ ! -L "$destination" ]]; then
        return
    fi

    destination_target="$(readlink "$destination")"
    if [[ "$destination_target" != "$source_file" ]]; then
        echo "skipped  $destination (points elsewhere)"
        return
    fi

    rm -f "$destination"
    echo "removed  $destination"
}

walk_package_files() {
    find \
        "$PACKAGE_ROOT/agents" \
        "$PACKAGE_ROOT/instructions" \
        "$PACKAGE_ROOT/skills" \
        -type f \
        -print0
}

cleanup_empty_dirs() {
    local github_dir="$1"
    local candidate

    for candidate in \
        "$github_dir/agents" \
        "$github_dir/instructions" \
        "$github_dir/skills"; do
        if [[ -d "$candidate" ]]; then
            find "$candidate" -depth -type d -empty -delete
        fi
    done

    if [[ -d "$github_dir/deep-research-v2" ]]; then
        find "$github_dir/deep-research-v2" -depth -type d -empty -delete
    fi
}

link_manifest_file() {
    local source_file="$1"
    local github_dir="$2"
    local destination

    destination="$github_dir/deep-research-v2/manifest.yaml"
    mkdir -p "$(dirname "$destination")"
    ln -sfn "$source_file" "$destination"
    echo "linked   $destination"
}

unlink_manifest_file() {
    local source_file="$1"
    local github_dir="$2"
    local destination
    local destination_target

    destination="$github_dir/deep-research-v2/manifest.yaml"

    if [[ ! -L "$destination" ]]; then
        return
    fi

    destination_target="$(readlink "$destination")"
    if [[ "$destination_target" != "$source_file" ]]; then
        echo "skipped  $destination (points elsewhere)"
        return
    fi

    rm -f "$destination"
    echo "removed  $destination"
}

install_links() {
    local github_dir="$1"
    local manifest_source_file
    local source_file

    mkdir -p "$github_dir"
    while IFS= read -r -d '' source_file; do
        link_file "$source_file" "$github_dir"
    done < <(walk_package_files)

    manifest_source_file="$PACKAGE_ROOT/manifest.yaml"
    link_manifest_file "$manifest_source_file" "$github_dir"
}

uninstall_links() {
    local github_dir="$1"
    local manifest_source_file
    local source_file

    if [[ ! -d "$github_dir" ]]; then
        echo "nothing to do: $github_dir does not exist"
        return
    fi

    while IFS= read -r -d '' source_file; do
        unlink_file "$source_file" "$github_dir"
    done < <(walk_package_files)

    manifest_source_file="$PACKAGE_ROOT/manifest.yaml"
    unlink_manifest_file "$manifest_source_file" "$github_dir"

    cleanup_empty_dirs "$github_dir"
}

main() {
    local command="${1:-}"
    local target_path="${2:-}"
    local github_dir

    if [[ -z "$command" || -z "$target_path" ]]; then
        usage
        exit 1
    fi

    github_dir="$(resolve_github_dir "$target_path")"

    case "$command" in
        install)
            echo "Installing v2 deep research links into $github_dir"
            install_links "$github_dir"
            ;;
        uninstall)
            echo "Removing v2 deep research links from $github_dir"
            uninstall_links "$github_dir"
            ;;
        -h|--help|help)
            usage
            ;;
        *)
            echo "ERROR: Unknown command: $command" >&2
            usage
            exit 1
            ;;
    esac
}

main "$@"