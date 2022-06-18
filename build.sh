#!/usr/bin/env bash
latest_version=$(curl -s "https://api.github.com/repos/caddyserver/caddy/releases/latest" | grep "tag_name" | cut -d\" -f4 | sed -e "s/^v//" -e "s/-.$//" | cut -d"v" -f 2)
test -f caddy && current_version=$(./caddy_amd64 version | cut -d" " -f 1 | cut -d"v" -f 2) || current_version='caddy not found'
if [[ ${latest_version} == ${current_version} ]]
then
    echo 'there is nothing to do'
else
    git config --local user.name 'GitHub Action'
    git config --local user.email 'action@github.com'
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
    for arch in amd64 arm64
    do
        env GOOS=linux GOARCH=${arch} xcaddy build latest \
        --with github.com/caddy-dns/cloudflare \
        --with github.com/mholt/caddy-l4 \
        --with github.com/mholt/caddy-webdav \
        --with github.com/lindenlab/caddy-s3-proxy \
        --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive \
        --output caddy_${arch}
        git add caddy_${arch}
    done
    git commit -am ${latest_version}
    git push -v --progress
fi
