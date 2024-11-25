#!/bin/bash

# Define the machines
machines=("DEV" "SERVER")
modes=("nodejs" "python" "all")

multifactor_auth=("include" "ignore")
multifactor_flag=0
remoteit_mode=("include" "ignore")
remoteit_flag=0
remoteit_code=""

# Prompt the user to select a machine
echo "Select a machine:"
select machine in "${machines[@]}"; do
    case $machine in
        "DEV")
            break
            ;;
        "SERVER")
            break
            ;;
        *)
            echo "Invalid option, please select again."
            ;;
    esac
done

echo "SELECTED MACHINE TYPE: $machine"
printf "\n"
printf "\n"

# Prompt the user to select a mode based on the selected machine
echo "Select a mode for $machine:"
select mode in "${modes[@]}"; do
    case $mode in
        "nodejs")
            break
            ;;
        "python")
            break
            ;;
        "all")
            break
            ;;
        *)
            echo "Invalid option, please select again."
            ;;
    esac
done

# Display the selected mode
echo "SELECTED MODE: $mode" 
printf "\n"
printf "\n"


# Prompt the user to include/exclude 2FA
echo "Choose to include/ignore multifactor authentication:"
select opt in "${multifactor_auth[@]}"; do
    case $opt in
        "include")
            multifactor_flag=1
            break
            ;;
        "ignore")
            multifactor_flag=0
            break
            ;;
        *)
            echo "Invalid option, please select again."
            ;;
    esac
done

# Display the selected mode
echo "Selected mode: $opt" 
printf "\n"
printf "\n"

# Prompt the user to include/exclude RemoteIT Agent
echo "Choose to include/ignore RemoteIT Agent:"
select opt in "${remoteit_mode[@]}"; do
    case $opt in
        "include")
            remoteit_flag=1
            break
            ;;
        "ignore")
            remoteit_flag=0
            break
            ;;
        *)
            echo "Invalid option, please select again."
            ;;
    esac
done

# Display the selected mode
echo "Selected mode: $opt" 
printf "\n"
printf "\n"

case $remoteit_flag in
    1)
        read -p "Enter RemoteIT Agent code:" remoteit_code
esac
printf "\n"
printf "\n"

# install core packages
# export LC_ALL=$LANG.UTF-8
export MODE=$machine
export INCLUDE_2FA=$multifactor_flag
export INCLUDE_REMOTEIT_AGENT=$remoteit_flag

echo "machine : $machine"
echo "mode : $mode"

ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/common.yml -e "remoteit_agent_code=$remoteit_code" --ask-become-pass 

case $mode in
    "nodejs")
        ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/nodejs.yml --ask-become-pass;;
    "python")
        ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/python.yml --ask-become-pass;;
    "all")
        ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/python.yml --ask-become-pass
        ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/nodejs.yml --ask-become-pass;;
    *)
        echo "mode is not set";;
esac

echo "Setup complete!"