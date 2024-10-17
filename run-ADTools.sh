#!/bin/bash

TOOLS_DIR=~/tools

# Define the command to run for each tool
declare -A tool_commands
tool_commands=(
    ["BloodHound"]="cd $TOOLS_DIR/BloodHound && npm start"
    ["SharpHound"]="wine $TOOLS_DIR/SharpHound/SharpHound.exe"
    ["PowerView"]="pwsh -c '. $TOOLS_DIR/PowerSploit/Recon/PowerView.ps1'"
    ["ADRecon"]="pwsh -c '. $TOOLS_DIR/ADRecon/ADRecon.ps1'"
    ["LDAPDomainDump"]="ldapdomaindump"
    ["CrackMapExec"]="crackmapexec"
    ["PingCastle"]="mono $TOOLS_DIR/pingcastle/PingCastle.exe"
    ["Mimikatz"]="wine $TOOLS_DIR/mimikatz/Win32/mimikatz.exe"
    ["Rubeus"]="mono $TOOLS_DIR/Rubeus/Rubeus.exe"
    ["SharpKatz"]="wine $TOOLS_DIR/SharpKatz/SharpKatz.exe"
    ["LaZagne"]="python3 $TOOLS_DIR/LaZagne/laZagne.py"
    ["Impacket"]="python3 $TOOLS_DIR/impacket/examples/smbexec.py"
    ["RemotePotato0"]="wine $TOOLS_DIR/RemotePotato0/RemotePotato0.exe"
    ["Juicy Potato"]="wine $TOOLS_DIR/juicy-potato/JuicyPotato.exe"
    ["Rogue Potato"]="wine $TOOLS_DIR/RoguePotato/RoguePotato.exe"
    ["Nishang"]="pwsh -c '. $TOOLS_DIR/nishang'"
    ["SharpPersist"]="wine $TOOLS_DIR/SharPersist/SharpPersist.exe"
    ["Evil-WinRM"]="evil-winrm"
    ["SafetyKatz"]="wine $TOOLS_DIR/SafetyKatz/SafetyKatz.exe"
    ["Certipy"]="certipy"
    ["Nmap"]="nmap"
    ["Responder"]="responder"
    ["John the Ripper"]="john"
    ["Hashcat"]="hashcat"
    ["Empire"]="powershell-empire"
    ["Kerbrute"]="cd $TOOLS_DIR && ./kerbrute"
    ["NTLMRelayX"]="python3 $TOOLS_DIR/impacket/examples/ntlmrelayx.py"
    ["Enum4Linux"]="enum4linux"
    ["Metasploit Framework"]="msfconsole"
)

# Display menu with numbered options in three columns
echo "The following tools are available."
echo "Tools that cannot be run from the command line are located at ~/tools."
index=1
for tool_name in "${!tool_commands[@]}"; do
    if (( index % 3 == 1 )); then
        printf "%-25s" "$index) $tool_name"
    elif (( index % 3 == 2 )); then
        printf "%-25s" "$index) $tool_name"
    else
        printf "%-25s\n" "$index) $tool_name"
    fi
    tool_names[$index]="$tool_name"
    ((index++))
done
# Print a newline if the last line was not completed
if (( (index - 1) % 3 != 0 )); then
    echo
fi




