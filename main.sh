#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:~/go/bin:/usr/local/go/bin; export PATH

latest_version=$(curl -s "https://api.github.com/repos/caddyserver/caddy/releases/latest" | grep "tag_name" | cut -d\" -f4 | sed -e "s/^v//" -e "s/-.$//" | cut -d"v" -f 2)
test -f caddy && current_version=$(./caddy version | cut -d" " -f 1 | cut -d"v" -f 2) || current_version='caddy not found'

if [[ ${latest_version} == ${current_version} ]]
then
    echo 'there is nothing to do'
else
    go get -u github.com/caddyserver/xcaddy/cmd/xcaddy

    xcaddy build latest \
        --with github.com/caddy-dns/cloudflare \
        --with github.com/mholt/caddy-l4 \
        --with github.com/mholt/caddy-webdav \
        --with github.com/lindenlab/caddy-s3-proxy \
        --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive
    
    git config --local user.name 'GitHub Action'
    git config --local user.email 'action@github.com'
    git add caddy
    git commit -am ${latest_version}
    git push -v --progress

    docker login -u $DOCKER_USER -p $DOCKER_PASS
    docker build -t ${{secrets.DOCKER_USER}}/caddy:latest -t ${{secrets.DOCKER_USER}}/caddy:${latest_version} .
    docker push ${{secrets.DOCKER_USER}}/caddy
fi