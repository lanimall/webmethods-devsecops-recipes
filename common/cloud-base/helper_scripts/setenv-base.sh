#!/usr/bin/env bash

##some vars for the CLI interactions
export BASTION_SSH_HOST="${bastion_public_ip}"
export BASTION_SSH_USER="${bastion_user}"
export BASTION_SSH_PUB_KEY_PATH="${bastion_ssh_publickey_path}"
export INTERNAL_SSH_PUB_KEY_PATH="${internal_ssh_publickey_path}"
export EXTERNAL_WEB_DOMAIN="${dns_main_external_apex}"