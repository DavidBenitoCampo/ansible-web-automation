#!/bin/bash
# Runs docker-bench-security against the current Docker environment

echo "Starting Docker Security Audit..."
echo "This will check for common best-practices and security configurations."
echo "Reference: https://github.com/docker/docker-bench-security"

docker run --rm \
    --net host \
    --pid host \
    --userns host \
    --cap-add audit_control \
    -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/systemd:/usr/lib/systemd \
    --label docker_bench_security \
    docker/docker-bench-security
