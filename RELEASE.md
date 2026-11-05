# Release process

## 1. Pick the version

We follow [semver](https://semver.org/). Until `1.0.0`:

- **MINOR** (`0.x.0`) — breaking changes in the `cscli` API or in the structure of
  the command scripts under `scripts/`.
- **PATCH** (`0.x.z`) — new commands (new software available), bug fixes, docs.

Check the current version with:

```
git describe --tags
```

## 2. Update the version files

```
make release VERSION=${NEW_VERSION}
```

This runs `release.sh`, which rewrites the version in two places:

- `install.sh` — the fallback `VERSION=` used when the caller does not pin one.
- `scripts/cscli` — the `VERSION=` that resolves `/opt/cloudscripts-${VERSION}`.
- `README.md` — the pinned-version example in the installation section.

Review the result before committing:

```
git diff
```

## 3. Commit and tag

```
git add -A
git commit -m "bump version ${NEW_VERSION}"
git tag -a ${NEW_VERSION} -m "Release ${NEW_VERSION}"
```

## 4. Push the commit *and* the tag

```
git push origin main --follow-tags
```

A plain `git push` does not push tags. The tag is not optional: `install.sh`
downloads `archive/refs/tags/${VERSION}.tar.gz` from GitHub, so the default
installation stays broken until the tag exists upstream.

## 5. Verify

Installing fetches `install.sh` from `main` and the tarball from the new tag:

```
curl -Ls https://raw.githubusercontent.com/nuxion/cloudscripts/main/install.sh | sh
cscli version
```

Old installations are never removed — they stay in `/opt/cloudscripts-${VERSION}`
— but `/usr/local/bin/cscli` is replaced to point at the new one.
