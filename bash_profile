#!/usr/bin/env bash

export DEVENV_VER='v2.0.1'

# -------------------------------------------------------------------------
echo ''
echo ":: Configuring aliases for George devenv [${DEVENV_VER}]:"
echo ''
echo '   $ dc:            short for docker-compose'
echo '   $ dhalt:         stop all containers'
echo '   $ dwipeout:      stop and remove all containers'
echo '   $ dnontagged:    remove non tagged images'
echo '   $ ecr-login:     log in to aws ecr'
echo '   $ mvn:           dockerized maven builder'
echo '   $ node:          dockerized node.js'
echo '   $ npm:           dockerized node.js package manager'
echo '   $ go-builder:    dockerized golang builder'
echo '   $ go:            dockerized go tool'
echo '   $ groovy:        dockerized groovy tool'
echo '   $ kops:          dockerized kops tool'
echo '   $ constable:     dockerized kubernetes cluster builder'
echo '   $ kubectl-proxy: run kubectl proxy, making it available to the outside (host machine)'
echo ''

alias dc='docker-compose "$@"'
alias dhalt='docker stop $(docker ps -a -q)'
alias dwipeout='dhalt && docker rm $(docker ps -a -q)'
alias dnontagged="docker rmi $(docker images | grep '^<none>' | awk '{print $3}')"
alias ecr-login='$(aws ecr get-login --region us-west-2)'

alias mvn='docker run --rm -v ~/shared/.m2:/var/maven/.m2 -v $PWD:/app -w /app -ti -e MAVEN_CONFIG=/var/maven/.m2 maven:3.3.9-jdk-8 mvn -Duser.home=/var/maven'
alias go-builder='docker run --rm -v $PWD:/go/src/app -ti go-builder'
alias go='docker run --rm -v ~/shared/go/src:/go/src -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e http_proxy=$http_proxy -e https_proxy=$https_proxy golang:1.6 go'
alias groovy='docker run --rm -v ~/shared/.grapes:/graperoot -v $(pwd):/source -e JAVA_OPTS="-Dhttp.proxyHost=web-proxy.corp.hp.com -Dhttp.proxyPort=8080 -Dhttps.proxyHost=web-proxy.corp.hp.com -Dhttps.proxyPort=8080" webratio/groovy'
alias node='docker run --rm -v ~/shared/.npm:/home/node/.npm -v $PWD:/app -w /app -ti node:6-alpine node'
alias npm='docker run --rm -v ~/shared/.npm:/home/node/.npm -v $PWD:/app -w /app -ti node:6-alpine npm'

alias kops='docker run --rm -v ~/shared/.ssh:/root/.ssh -v /etc/ssl:/etc/ssl -v ~/.kube:/root/.kube -v ~/.aws:/root/.aws -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e KOPS_STATE_STORE=$KOPS_STATE_STORE -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e KUBECONFIG=$KUBECONFIG 957591566260.dkr.ecr.us-west-2.amazonaws.com/cwp/george-constable:latest kops'
alias constable='docker run --rm -e HOME=$HOME -v ~/shared/.ssh:$HOME/.ssh -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e KUBECONFIG=$KUBECONFIG -v /etc/ssl:/etc/ssl -v ~/.kube:$HOME/.kube 957591566260.dkr.ecr.us-west-2.amazonaws.com/cwp/george-constable:latest constable'
alias kubectl-proxy='kubectl proxy --address 0.0.0.0'


if [ -f "${HOME}/.devenv_profile" ]; then
  source ~/.devenv_profile
fi

export PATH="$PATH:/home/ubuntu/bin"
