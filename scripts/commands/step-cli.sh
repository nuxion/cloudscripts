#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


STEP_VERSION=0.18.2
STEP_CLI_TAR="https://github.com/smallstep/cli/releases/download/v${STEP_VERSION}/step_linux_${STEP_VERSION}_amd64.tar.gz"

if ! command -v step &> /dev/null
then
	echo "step-cli not found"
	curl -s -L $STEP_CLI_TAR > /tmp/step.tar.gz
	mkdir /tmp/step
	cd /tmp/step
	tar xvfz /tmp/step.tar.gz
	cp /tmp/step/step_${STEP_VERSION}/bin/step /usr/local/bin
	echo "step-cli installed"
	step --version
else
	echo "step-cli found"
fi
