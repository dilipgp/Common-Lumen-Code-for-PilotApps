export GITHUB_APP_ID="888447"
export GITHUB_INSTALLATION_ID="50218329"
export GITHUB_PRIVATE_KEY_PATH="ccoe-gh-actions-runner.2024-08-19.private-key.pem"

export RUNNER_RELEASE="v2.303.0/actions-runner-linux-x64-2.303.0.tar.gz"  # Optional
export RUNNER_GROUP="CCOE"
export RUNNER_LABELS="self-hosted,Linux,X64,Ubuntu,ccoe-runner"
export ANSIBLE_HOST_KEY_CHECKING=False

if ! command -v sshpass &> /dev/null
then
    echo "sshpass could not be found, installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install hudochenkov/sshpass/sshpass
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install -y sshpass
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        choco install sshpass
    else
        echo "Unsupported OS. Please install sshpass manually."
        exit 1
    fi
fi

if ! command -v expect &> /dev/null
then
    echo "expect could not be found, attempting to install..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y expect
        elif command -v yum &> /dev/null; then
            sudo yum install -y expect
        else
            echo "Unsupported package manager. Please install expect manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install expect
        else
            echo "Homebrew is not installed. Please install Homebrew and try again."
            exit 1
        fi
    else
        echo "Unsupported OS. Please install expect manually."
        exit 1
    fi
else
    echo "expect is already installed."
fi

if [ ! -f "$GITHUB_PRIVATE_KEY_PATH" ]; then
    echo "Error: PEM file $GITHUB_PRIVATE_KEY_PATH does not exist. Exiting."
    exit 1
fi

read -r -p "Enter Unix / Ansible user (e.g., jatienza): " ansible_user
if [ -z "$ansible_user" ]; then
    echo "Ansible user cannot be empty. Exiting."
    exit 1
fi

read -r -p "Enter a comma-separated list of servers (e.g., usodclvccoegar1-prod.corp.intranet, usodclvccoegar2-prod.corp.intranet): " servers
if [ -z "$servers" ]; then
    echo "Server list cannot be empty. Exiting."
    exit 1
fi

hosts_file="hosts.ini"
echo "[github_runners]" > "$hosts_file"
IFS=',' read -ra ADDR <<< "$servers"
for server in "${ADDR[@]}"; do
    trimmed_server=$(echo "$server" | xargs)  # Trim leading/trailing whitespace
    echo "$trimmed_server ansible_user=$ansible_user" >> "$hosts_file"
done

echo "hosts.ini file created successfully."

read -r -p "Enter MobilePass+ passcode:" mobile_passcode
if [ -z "$mobile_passcode" ]; then
  echo "Passcode cannot be empty. Exiting."
  exit 1
fi

timestamp=$(date +%s%N)
ctrl_socket="/tmp/ctrl-socket-$timestamp"

while IFS= read -r line; do
    if [[ $line == *"ansible_user="* ]]; then
         server=$(echo $line | cut -d' ' -f1)
         user=$(echo $line | awk -F 'ansible_user=' '{print $2}' | awk '{print $1}')

        ./ssh_pass_thru.sh "$mobile_passcode" "$server" "$user" "$ctrl_socket"

        echo "Checking ssh socket connection: $ctrl_socket"
        if [ ! -e "$ctrl_socket" ]; then
            echo "Error: Control socket $ctrl_socket does not exist. Exiting."
            exit 1
        fi

        ANSIBLE_SSH_ARGS="-o ControlPath=$ctrl_socket" ansible-playbook -i hosts.ini --limit "$server" setup_github_runner.yml

        echo "Closing ssh socket connection: $ctrl_socket"
        ssh -S $ctrl_socket -O exit "$user@$server"
        rm -rf $ctrl_socket
    fi
done < hosts.ini
