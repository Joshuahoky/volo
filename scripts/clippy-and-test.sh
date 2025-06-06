#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo_command() {
	echo "$@"

	if [ "${GITHUB_ACTIONS:-}" = "true" ] || [ -n "${DEBUG:-}" ]; then
		# If we are in GitHub Actions or env `DEBUG` is non-empty,
		# output all
		"$@"
	else
		# Disable outputs
		"$@" > /dev/null 2>&1
	fi
}

# Setup error handler
trap 'echo "Failed to run $LINENO: $BASH_COMMAND (exit code: $?)" && exit 1' ERR

# Clippy
echo_command cargo clippy -p volo-thrift --no-default-features -- --deny warnings
echo_command cargo clippy -p volo-thrift --no-default-features --features multiplex -- --deny warnings
echo_command cargo clippy -p volo-thrift --no-default-features --features unsafe-codec -- --deny warnings
echo_command cargo clippy -p volo-grpc --no-default-features -- --deny warnings
echo_command cargo clippy -p volo-grpc --no-default-features --features rustls -- --deny warnings
echo_command cargo clippy -p volo-grpc --no-default-features --features native-tls -- --deny warnings
echo_command cargo clippy -p volo-grpc --no-default-features --features native-tls-vendored -- --deny warnings
echo_command cargo clippy -p volo-grpc --no-default-features --features grpc-web -- --deny warnings
echo_command cargo clippy -p volo-http --no-default-features -- --deny warnings
echo_command cargo clippy -p volo-http --no-default-features --features client,http1,json -- --deny warnings
echo_command cargo clippy -p volo-http --no-default-features --features client,http2,json -- --deny warnings
echo_command cargo clippy -p volo-http --no-default-features --features server,http1,query,form,json,multipart,ws -- --deny warnings
echo_command cargo clippy -p volo-http --no-default-features --features server,http2,query,form,json,multipart,ws -- --deny warnings
echo_command cargo clippy -p volo-http --no-default-features --features full -- --deny warnings
echo_command cargo clippy -p volo -- --deny warnings
echo_command cargo clippy -p volo --no-default-features --features rustls-aws-lc-rs -- --deny warnings
echo_command cargo clippy -p volo --no-default-features --features rustls-ring -- --deny warnings
echo_command cargo clippy -p volo-build -- --deny warnings
echo_command cargo clippy -p volo-cli -- --deny warnings
echo_command cargo clippy -p volo-macros -- --deny warnings
echo_command cargo clippy -p examples -- --deny warnings
echo_command cargo clippy -p examples --features tls -- --deny warnings

# Test
echo_command cargo test -p volo-thrift
echo_command cargo test -p volo-grpc --features rustls
echo_command cargo test -p volo-http --features client,server,http1,query,form,json,tls,cookie,multipart,ws
echo_command cargo test -p volo-http --features client,server,http2,query,form,json,tls,cookie,multipart,ws
echo_command cargo test -p volo-http --features full
echo_command cargo test -p volo --features rustls
echo_command cargo test -p volo-build
echo_command cargo test -p volo-cli
