
#!/bin/bash

USE_SYN_SCAN=false USE_VERBOSE_SCAN=false USE_OS_DETECTION=false
USE_PINGING=false

# ask the user for an IP Adress
read -p "Enter the target IP Adress to scan: " TARGET_IP

# ask the user for the target ports to scan
read -p "Enter the needed ports to scan: " TARGET_PORTS

#ask the user if they want to use a timing template
read -p "Do you want to use a timing template? (y/n): " choice

# ask the user to select a timing template  (T1 to T5)
if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "Select the Timing Template  (T1 to T5):"
        echo "T1 - Slow scan (least intrusive)"
        echo "T2 - Polite scan"
        echo "T3 - Normal scan"
        echo "T4 - Aggressive scan"
        echo "T5 - Very aggressive scan"
        read -p "Enter your choice (1-5): " TEMPLATE_CHOICE

# Set the timing template based on the user's choice
case $TEMPLATE_CHOICE in
        1) TIMING_TEMPLATE="-T1" ;;
        2) TIMING_TEMPLATE="-T2" ;;
        3) TIMING_TEMPLATE="-T3" ;;
        4) TIMING_TEMPLATE="-T4" ;;
        5) TIMING_TEMPLATE="-T5" ;;
        *)
                echo  "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Inform the user about the selected timing template

echo "You selected Timing Template: $TEMPLATE_CHOICE ($TIMING_TEMPLATE)"

else
        echo "No Timing Template selected."
fi

# ask the user if they is supposed to be a silent scan
read -p "Do you want the scan to be hidden? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
        USE_SYN_SCAN=true
        echo "Silent Scan used."

elif [[ "$choice" =~ ^[Nn]$ ]]; then
        USE_SYN_SCAN=false
        echo "No Silent Scan."
else    echo "Invalid Input. Exiting."
        exit 1
fi

# ask the user if it wants the Scan to be verbose

read -p "Do you want the scan to be verbose? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
        USE_VERBOSE_SCAN=true
        echo "Verbose scan will be running..."

elif [[ "$choice" =~ ^[Nn]$ ]]; then
        USE_VERBOSE_SCAN=false
        echo "verbose scan will not be running."
fi

# ask the user if it wants the OS to be detected

read -p "Do you want to detect the OS? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
        USE_OS_DETECTION=true
        echo "OS Detection will be running..."

elif [[ "$choice" =~ ^[Nn]$ ]]; then
        USE_OS_DETECTION=false
        echo "No OS detection will be running."
else echo "Invalid Input. Exiting." exit 1
fi

# ask if the User wants to ping the Target IP
read -p "Do you want to ping the Target IP? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
        USE_PINGING=true
        echo "Openly pinging target IP address..."

elif [[ "$choice" =~ ^[Nn]$ ]]; then
        USE_PINGING=false
        echo "Not pinging target IP adress."

else    echo "Invalid Input. Exiting."
        exit 1

fi

CMD="sudo nmap $TIMING_TEMPLATE -p $TARGET_PORTS $TARGET_IP"

if [[ "$USE_SYN_SCAN" == true ]]; then
        CMD="$CMD -sS"
fi
if [[ "$USE_VERBOSE_SCAN" == true ]]; then
        CMD="$CMD -v"
fi
if [[ "$USE_OS_DETECTION" == true ]]; then
        CMD="$CMD -O"
fi
if [[ "$USE_PINGING" == false ]]; then
        CMD="$CMD -Pn"
fi

# Execute the final Nmap command

echo "Running Nmap with following command:"
echo $CMD
$CMD

echo "Scan completed."
