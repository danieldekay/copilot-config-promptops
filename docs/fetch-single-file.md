# Fetch a single file from another Git repo

Several safe options exist depending on whether the repo is public or private and which tooling you prefer.

1) Git sparse-checkout (recommended for automation and private repos)

```bash
# clone minimally and checkout only the specific path
git clone --filter=blob:none --no-checkout git@github.com:ORG/REPO.git tmp-repo
cd tmp-repo
git sparse-checkout init --cone
git sparse-checkout set path/to/file.md
git checkout main
# copy the file out
cp path/to/file.md ../path/to/dest/
cd .. && rm -rf tmp-repo
```

1) git archive (fetch a single file via SSH, works well for scripts)

```bash
# outputs a tar stream with the file
git archive --remote=git@github.com:ORG/REPO.git HEAD path/to/file.md | tar -xO > file.md
```

1) svn export (GitHub public repos only)

```bash
svn export https://github.com/ORG/REPO/trunk/path/to/file.md file.md
```

1) gh / curl (public or private via auth)

```bash
# public raw file
curl -sL https://raw.githubusercontent.com/ORG/REPO/main/path/to/file.md -o file.md

# private repo — use gh or authenticated header (avoid printing tokens in logs)
gh api repos/ORG/REPO/contents/path/to/file.md --jq ".content" | base64 --decode > file.md
```

Notes & security

- For private repos prefer SSH-based methods (sparse-checkout or git archive) so you rely on existing Git auth. Avoid embedding PATs in scripts or CI logs.
- Sparse-checkout is efficient and robust; it mirrors the approach used by the Makefile sync pattern in this repo.
- If you need to sync multiple files or directories, prefer sparse-checkout or a shallow clone instead of repeated curl requests.
