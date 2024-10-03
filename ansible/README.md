# Ansible Setup for Self-Hosted GitHub Runners

## Introduction
This Ansible setup is designed to configure self-hosted GitHub runners on Lumen internal machines. The setup requires a mobile pass token for authentication.

## Environment Variables
The `setup.sh` script contains several environment variables that can be modified to suit your needs:
- `GITHUB_APP_ID`: The GitHub App ID.
- `GITHUB_INSTALLATION_ID`: The GitHub Installation ID.
- `GITHUB_PRIVATE_KEY_PATH`: Path to the private key file in your local machine. This PEM can be created in the GitHub App settings.
- `RUNNER_RELEASE`: The release version of the GitHub runner.
- `RUNNER_GROUP`: The runner group name.
- `RUNNER_LABELS`: Labels for the runner.
- `ANSIBLE_HOST_KEY_CHECKING`: Set to `False` to disable host key checking.

You can change these variables directly in the `setup.sh` script.

## Hosts Configuration
The `hosts.ini` file contains the user and hosts information. This file is updated prompting by the servers and ansible user in the setup.sh script
- `ansible_user`: The user to use for SSH connections.
- `hosts`: The list of hosts where the GitHub runners will be installed.

## Pre-requirements
Before executing the `setup.sh` script, ensure the following pre-requirements are met:
- You must have access to the target machines.
- You need to have `sudo` privileges as the script requires elevated permissions (`become: yes`).

## Goal
The goal of this Ansible setup is to configure self-hosted GitHub runners on Lumen internal machines. The setup uses a mobile pass token for authentication and ensures that the runners are properly installed and configured.