#!/usr/bin/env bash

export DEVENV_VER='v1.0.0'

# -------------------------------------------------------------------------
echo ''
echo ":: Configuring aliases for Mior devenv [${DEVENV_VER}]:"
echo ''
echo '   $ dc:            short for docker-compose'
echo '   $ dhalt:         stop all containers'
echo '   $ dwipeout:      stop and remove all containers'
echo '   $ dnontagged:    remove non tagged images'
echo '   $ mvn:           dockerized maven builder'
echo '   $ node:          dockerized node.js'
echo '   $ npm:           dockerized node.js package manager'
echo '   $ go:            dockerized go tool'
echo '   $ groovy:        dockerized groovy tool'
echo '   $ gradle:        dockerized gradle tool'
echo '   $ irb:           dockerized ruby irb tool'
echo '   $ gem:           dockerized ruby gem tool'
echo '   $ rake:          dockerized ruby rake tool'
echo '   $ rspec:         dockerized ruby rspec tool'
echo '   $ bundle:        dockerized ruby bundle tool'
echo '   $ rubocop:       dockerized ruby rubocop tool'
echo '   $ yard:          dockerized ruby yard tool'
echo ''

alias dc='docker-compose "$@"'
alias dhalt='docker stop $(docker ps -a -q)'
alias dwipeout='dhalt && docker rm $(docker ps -a -q)'
alias dnontagged="docker rmi $(docker images | grep '^<none>' | awk '{print $3}')"
#alias ecr-login='$(aws ecr get-login --region us-west-2)'

alias mvn='docker run --rm -v ~/shared/.m2:/var/maven/.m2 -v $PWD:/app -w /app -ti -e MAVEN_CONFIG=/var/maven/.m2 maven:3.3.9-jdk-8 mvn -Duser.home=/var/maven'
alias go='docker run --rm -v ~/shared/go/src:/go/src -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e http_proxy=$http_proxy -e https_proxy=$https_proxy golang:1.6 go'
alias groovy='docker run --rm -v ~/shared/.grapes:/graperoot -v $(pwd):/source -e JAVA_OPTS="-Dhttp.proxyHost=web-proxy.corp.hp.com -Dhttp.proxyPort=8080 -Dhttps.proxyHost=web-proxy.corp.hp.com -Dhttps.proxyPort=8080" webratio/groovy'
alias node='docker run --rm -v ~/shared/.npm:/home/node/.npm -v $PWD:/app -w /app -ti node:6-alpine node'
alias npm='docker run --rm -v ~/shared/.npm:/home/node/.npm -v $PWD:/app -w /app -ti node:6-alpine npm'

alias gem='docker run -it --rm  -e http_proxy=$http_proxy -e https_proxy=$https_proxy -v $HOME/.gems:/usr/local/bundle -v $PWD:/usr/src/myapp -w /usr/src/myapp ruby:2.1 gem'
alias irb='docker run -it --rm -v $HOME/.gems:/usr/local/bundle -v $PWD:/usr/src/myapp -w /usr/src/myapp ruby:2.1'
alias rake='docker run -it --rm -v $HOME/.gems:/usr/local/bundle -v $PWD:/usr/src/myapp -w /usr/src/myapp ruby:2.1 rake'
alias rspec='docker run -it --rm -v $HOME/.gems:/usr/local/bundle -v $PWD:/usr/src/myapp -w /usr/src/myapp ruby:2.1 rspec'
alias bundle='docker run -it --rm -e http_proxy=$http_proxy -e https_proxy=$https_proxy -v /usr/bin/git:/usr/bin/git -v $HOME/.gems:/usr/local/bundle -v $PWD:/usr/src/myapp -w /usr/src/myapp ruby:2.1 bundle'
alias rubocop='docker run -it --rm -v $HOME/.gems:/usr/local/bundle -v $PWD:/usr/src/myapp -w /usr/src/myapp ruby:2.1 rubocop'
alias yard='docker run -it --rm -v $HOME/.gems:/usr/local/bundle -v $PWD:/usr/src/myapp -w /usr/src/myapp ruby:2.1 yard'


if [ -f "${HOME}/.devenv_profile" ]; then
  source ~/.devenv_profile
fi

export PATH="$PATH:/home/ubuntu/bin"
