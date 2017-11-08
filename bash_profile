#!/usr/bin/env bash

# -------------------------------------------------------------------------
echo ''
echo ":: Configuring aliases for GCD Development Environment:"
echo ''
echo '   :: Utilities:'
echo ''
echo '   $ dc:            short for docker-compose'
echo '   $ ecr-login:     log in to aws ecr'
echo '   $ kubectl-proxy: run kubectl proxy, making it available to the outside (host machine)'
echo ''
echo '   :: Applications as Docker Containers:'
echo ''
echo '   $ berks:         dockerized berkshelf'
echo '   $ bundle:        dockerized ruby bundle'
echo '   $ gcloud:        dockerized gcloud client tool'
echo '   $ gem:           dockerized ruby gem'
echo '   $ go:            dockerized golang'
echo '   $ gradle:        dockerized gradle'
echo '   $ groovy:        dockerized groovy'
echo '   $ irb:           dockerized ruby irb'
echo '   $ mvn:           dockerized maven'
echo '   $ node:          dockerized node.js'
echo '   $ npm:           dockerized node.js package manager'
echo '   $ rails:         dockerized ruby rails'
echo '   $ rake:          dockerized ruby rake'
echo '   $ rspec:         dockerized ruby rspec'
echo '   $ rubocop:       dockerized ruby rubocop'
echo '   $ ruby:          dockerized ruby'
echo '   $ vault:         dockerized vault cli'
echo '   $ yard:          dockerized ruby yard'
echo '   $ yarn:          dockerized node.js package manager'
echo ''

alias dc='docker-compose "$@"'

# Login into AWS ECR
#
# In order to define which parameter it uses, in order:
#  1. Method call parameter
#  2. Environment variable AWS_PROFILE
#  3. The value default
#
# param 1 the profile to use
ecr-login() {
  profile=${1:-${AWS_PROFILE:-default}}
  echo "Logging into AWS ECR using the profile ${profile}"
  $(aws ecr get-login --region us-west-2 --profile ${profile} --no-include-email)
}

if [ -f "${HOME}/.devenv_profile" ]; then
  source ${HOME}/.devenv_profile
fi

export PATH="$PATH:/home/vagrant/bin"

# Docker system prune (dangling images, volumes, networks and unused containers)
echo "Docker system prune..."
docker system prune -f
