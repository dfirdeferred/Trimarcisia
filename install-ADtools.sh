#!/bin/bash

LOG_FILE="install_log.txt"
> $LOG_FILE  # Clear the log file

# Function to install each tool
install_tool() {
    echo "Installing $1..."
    echo "Installing $1..." >> $LOG_FILE
    eval "$2" >> $LOG_FILE 2>&1
    if [ $? -eq 0 ]; then
        echo "$1 installed successfully." >> $LOG_FILE
    else
        echo "Error installing $1. Check $LOG_FILE for details." >> $LOG_FILE
    fi
}

# Prompt user for installation mode
echo "Would you like to approve all installs automatically or approve each tool individually?"
read -p "(Type 'auto' for automatic, 'manual' for individual approval): " install_mode

if [[ "$install_mode" != "auto" && "$install_mode" != "manual" ]]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

# Update and install initial dependencies
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3 python3-pip build-essential wget unzip mono-complete apt-transport-https software-properties-common libssl-dev libffi-dev python3-dev smbclient ruby

# Install PowerShell
install_tool "PowerShell" "wget -q https://packages.microsoft.com/config/ubuntu/\$(lsb_release -rs)/packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && sudo apt update && sudo apt install -y powershell"

# Define tools and commands
tools=(
    "BloodHound" "mkdir ~/tools && cd ~/tools && git clone https://github.com/BloodHoundAD/BloodHound && cd BloodHound && npm install electron@13"
    "SharpHound" "wget https://github.com/BloodHoundAD/SharpHound/releases/latest/download/SharpHound.exe -P ~/tools/SharpHound"
    "PowerView" "cd ~/tools && git clone https://github.com/PowerShellMafia/PowerSploit"
    "ADRecon" "cd ~/tools && git clone https://github.com/sense-of-security/ADRecon"
    "LDAPDomainDump" "pip3 install ldapdomaindump"
    "CrackMapExec" "cd ~/tools && git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec && cd CrackMapExec && pip3 install -r requirements.txt && python3 setup.py install"
    "PingCastle" "cd ~/tools && wget https://github.com/vletoux/pingcastle/releases/latest/download/pingcastle.zip && unzip pingcastle.zip -d pingcastle"
    "Rubeus" "mkdir -p ~/tools/Rubeus && cd ~/tools/Rubeus && wget https://github.com/GhostPack/Rubeus/releases/latest/download/Rubeus.zip && unzip Rubeus.zip -d . && rm Rubeus.zip"
    "Mimikatz" "cd ~/tools && git clone https://github.com/gentilkiwi/mimikatz"
    "Invoke-Kerberoast" "echo 'Invoke-Kerberoast is part of PowerSploit. Refer to PowerView installation.'"
    "SharpKatz" "cd ~/tools && git clone https://github.com/b4rtik/SharpKatz"
    "LaZagne" "cd ~/tools && git clone https://github.com/AlessandroZ/LaZagne && cd LaZagne && python3 laZagne.py"
    "Impacket" "cd ~/tools && git clone https://github.com/SecureAuthCorp/impacket && cd impacket && pip3 install ."
    "RemotePotato0" "cd ~/tools && git clone https://github.com/antonioCoco/RemotePotato0"
    "Juicy Potato" "cd ~/tools && git clone https://github.com/ohpe/juicy-potato"
    "Rogue Potato" "cd ~/tools && git clone https://github.com/antonioCoco/RoguePotato"
    "Invoke-SMBExec" "echo 'Invoke-SMBExec is part of PowerSploit. Refer to PowerView installation.'"
    "Nishang" "cd ~/tools && git clone https://github.com/samratashok/nishang"
    "DCShadow" "echo 'DCShadow is part of Mimikatz. Refer to Mimikatz installation.'"
    "SharpPersist" "cd ~/tools && git clone https://github.com/fireeye/SharPersist"
    "Evil-WinRM" "gem install evil-winrm"
    "Invoke-ACLScanner" "echo 'Invoke-ACLScanner is part of PowerSploit. Refer to PowerView installation.'"
    "SafetyKatz" "cd ~/tools && git clone https://github.com/GhostPack/SafetyKatz"
    "Certipy" "cd ~/tools && git clone https://github.com/ly4k/Certipy && cd Certipy && python3 setup.py install"
    "Nmap" "sudo apt install -y nmap"
    "Responder" "sudo apt install -y responder"
    "John the Ripper" "sudo apt install -y john"
    "Hashcat" "sudo apt install -y hashcat"
    "Empire" "sudo apt install -y powershell-empire"
    "Kerbrute" "cd ~/tools && wget https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64 && chmod +x kerbrute_linux_amd64 && mv kerbrute_linux_amd64 kerbrute"
    "NTLMRelayX" "cd ~/tools && git clone https://github.com/SecureAuthCorp/impacket && cd impacket/examples && pip3 install ."
    "Enum4Linux" "sudo apt install -y enum4linux"
    "Metasploit Framework" "sudo apt install -y metasploit-framework"
)

# Loop through each tool for installation
for ((i=0; i<${#tools[@]}; i+=2)); do
    tool_name="${tools[i]}"
    tool_command="${tools[i+1]}"

    if [[ "$install_mode" == "manual" ]]; then
        read -p "Do you want to install $tool_name? (y/n): " choice
        if [[ "$choice" != "y" ]]; then
            echo "Skipping $tool_name" >> $LOG_FILE
            continue
        fi
    fi

    install_tool "$tool_name" "$tool_command"
done

echo "Installation complete. Check $LOG_FILE for details."
