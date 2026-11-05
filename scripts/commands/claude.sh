#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
# docs
#  https://code.claude.com/docs/en/setup
#
# Claude Code is installed from the signed apt repository published by
# Anthropic instead of the `curl https://claude.ai/install.sh | bash`
# native installer: the native one drops the binary in ~/.local of the
# user running it (root, in a provisioning context) and self updates in
# background, which is the opposite of what an image builder wants.
# The apt repo gives a system wide /usr/bin/claude and no auto update.
#
# CLAUDE_CHANNEL selects the release channel: "stable" (default, about a
# week behind, skips releases with major regressions) or "latest".
URL="https://downloads.claude.ai/claude-code/apt"
KEY_URL="https://downloads.claude.ai/keys/claude-code.asc"
KEYRING="/etc/apt/keyrings/claude-code.asc"
# fingerprint of "Anthropic Claude Code Release Signing <security@anthropic.com>"
KEY_FINGERPRINT="31DDDE24DDFAB679F42D7BD2BAA929FF1A7ECACE"
CHANNEL="${CLAUDE_CHANNEL:-stable}"

pkg="claude-code"
pkg_test="claude"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

package_exists() {
    dpkg -s "$@"
}

check_key(){
    # the repo is useless if the key is wrong: apt would fail later with
    # NO_PUBKEY BAA929FF1A7ECACE and a half configured sources.list.d
    fp=$(gpg --show-keys --with-colons "${KEYRING}" 2>/dev/null \
            | awk -F: '/^fpr:/ {print $10; exit}')
    if [ "${fp}" != "${KEY_FINGERPRINT}" ]; then
        echo -e "[X] ${red}unexpected signing key: ${fp:-none}${clear}"
        return 1
    fi
    echo -e "=> signing key verified: ${fp}"
}

install(){
    apt-get install apt-transport-https ca-certificates gnupg --yes
    # NOTE: mkdir, not `install -d`: this function is itself named install,
    # so calling install(1) here would recurse into it instead.
    mkdir -p /etc/apt/keyrings
    chmod 0755 /etc/apt/keyrings
    $CURL -fsSL "${KEY_URL}" -o "${KEYRING}"
    check_key || return 1
    echo "deb [signed-by=${KEYRING}] ${URL}/${CHANNEL} ${CHANNEL} main" \
        > /etc/apt/sources.list.d/claude-code.list
    apt-get update
    apt-get install ${pkg} --yes --no-install-recommends
}

verification(){
    package_exists ${pkg} > /dev/null 2>&1 && ${pkg_test} --version
}

clean(){
    echo "Nothing to clean"
}

if ! command_exists $pkg_test &> /dev/null
then
	echo -e "=> ${magenta}${pkg}${clear} not found!"
	echo -e "=> ${magenta}${pkg}${clear} installing from the ${CHANNEL} channel"
    install
    status=$?
    verification
    verif_status=$?
    if [ "$status" -eq 0 ] && [ "$verif_status" -eq 0 ]; then
	    echo -e "=> ${magenta}${pkg}${clear} ${green}installed!${clear}"
    else
	    echo -e "[X] ${red}${pkg} installation failed!${clear}"
        exit 1
    fi
    echo -e "=> Cleaning"
    clean
else
	echo -e "=> ${magenta}${pkg}${clear} found!"
fi
