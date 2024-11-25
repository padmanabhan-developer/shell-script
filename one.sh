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

echo "You selected: $machine"
echo "\n"
echo "\n\n"

# Prompt the user to select a mode based on the selected machine
echo "Select a mode for $machine:"
select opt in "${modes[@]}"; do
    case $opt in
        "nodejs")
            mode="${machine}_nodejs"
            break
            ;;
        "python")
            mode="${machine}_python"
            break
            ;;
        "all")
            mode="${machine}_all"
            break
            ;;
        *)
            echo "Invalid option, please select again."
            ;;
    esac
done

# Display the selected mode
echo "Selected mode: $mode" 
echo "\n\n"


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
echo "\n\n"

# Prompt the user to include/exclude RemoteIT Agent
echo "Choose to include/ignore multifactor authentication:"
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
echo "\n\n"

case $remoteit_flag in
    1)
        read -p "Enter RemoteIT Agent code: " remoteit_code
        break
        ;;
    0)
        break
        ;;
esac
echo "\n\n"

# install core packages
LC_ALL=$LANG.UTF-8 MODE=$machine INCLUDE_2FA=$multifactor_flag INCLUDE_REMOTEIT_AGENT=$remoteit_flag ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/common.yml -e "remoteit_agent_code=$remoteit_code" --ask-become-pass 

case $mode in
    "nodejs")
        LC_ALL=$LANG.UTF-8 MODE=$machine ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/nodejs.yml --ask-become-pass
        break
        ;;
    "python")
        LC_ALL=$LANG.UTF-8 MODE=$machine ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/python.yml --ask-become-pass
        break
        ;;
    "all")
        LC_ALL=$LANG.UTF-8 MODE=$machine ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/python.yml --ask-become-pass
        LC_ALL=$LANG.UTF-8 MODE=$machine ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $ANSIBLE_BASE_DIR/src/nodejs.yml --ask-become-pass
        break
        ;;


