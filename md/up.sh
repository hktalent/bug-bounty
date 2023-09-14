#!/bin/bash
function doDldZip {
  userName="$1"
  pName="$2"
  main="$3"
  wget -c -O "${pName}.zip" "https://github.com/${userName}/${pName}/archive/refs/heads/${main}.zip"
  unzip -x -o "${pName}.zip"
  mv "${pName}-${main}" "${pName}"
  rm -rf "${pName}.zip" "${pName}/.github"
}

# data
wget -c -O ../data/chaos-bugbounty-list.json 'https://github.com/projectdiscovery/public-bugbounty-programs/raw/main/chaos-bugbounty-list.json'
wget -c -O ../data/DefaultCreds-Cheat-Sheet.csv https://github.com/ihebski/DefaultCreds-cheat-sheet/raw/main/DefaultCreds-Cheat-Sheet.csv
mkdir -p Intruder
wget -c -O Intruder/xss-payload-list.txt https://github.com/payloadbox/xss-payload-list/raw/master/Intruder/xss-payload-list.txt

# readme
wget -c -O awesome-bugbounty-tools.md https://github.com/vavkamil/awesome-bugbounty-tools/raw/main/README.md
wget -c -O Awesome-Bugbounty-Writeups.md https://github.com/devanshbatham/Awesome-Bugbounty-Writeups/raw/master/README.md
wget -c -O A-Red-Teamer-diaries.md https://github.com/ihebski/A-Red-Teamer-diaries/raw/master/README.md
wget -c -O study-bug-bounty.md https://github.com/bobby-lin/study-bug-bounty/raw/master/README.md
wget -c -O djadmin-awesome-bug-bounty.md https://github.com/djadmin/awesome-bug-bounty/raw/master/README.md
wget -c -O awesome-hacker-search-engines.md https://github.com/edoardottt/awesome-hacker-search-engines/raw/main/README.md
wget -c -O awesome-oneliner-bugbounty.md https://github.com/dwisiswant0/awesome-oneliner-bugbounty/raw/master/README.md
wget -c -O Ignitetechnologies-bugbounty.md https://github.com/Ignitetechnologies/bugbounty/raw/main/README.md
wget -c -O xss-payload-list.md https://github.com/payloadbox/xss-payload-list/raw/master/README.md

wget -c -O Awesome-Cybersecurity-Handbooks.md https://github.com/0xsyr0/Awesome-Cybersecurity-Handbooks/raw/main/README.md

# md
# ssh-keys
# https://github.com/ihebski/DefaultCreds-cheat-sheet/
# cat bugbounty-cheatsheet.txt|xargs -I % proxychains4 -f /Users/51pwn/MyWork/for_hacker_md/v2ray51pwn/proxychains.conf  wget -c -O bugbounty-cheatsheet-% https://github.com/EdOverflow/bugbounty-cheatsheet/raw/master/cheatsheets/%
cat bugbounty-cheatsheet.txt|xargs -I % wget -c -O bugbounty-cheatsheet-% https://github.com/EdOverflow/bugbounty-cheatsheet/raw/master/cheatsheets/%

doDldZip "daffainfo" "AllAboutBugBounty" "master"
# gh repo clone swisskyrepo/PayloadsAllTheThings
doDldZip "swisskyrepo" "PayloadsAllTheThings" "master"
doDldZip "lutfumertceylan" "top25-parameter" "master"
doDldZip "1N3" "Sn1per" "master"
doDldZip "1N3" "BruteX" "master"
doDldZip "1N3" "Findsploit" "master"
doDldZip "nahamsec" "Resources-for-Beginner-Bug-Bounty-Hunters" "master"

doDldZip "aufzayed" "bugbounty" "main"
doDldZip "0xmaximus" "Galaxy-Bugbounty-Checklist" "main"
doDldZip "akr3ch" "BugBountyBooks" "main"
# https://github.com/arkadiyt/bounty-targets
doDldZip "arkadiyt" "bounty-targets-data" "main"
doDldZip "Osb0rn3" "bugbounty-targets" "main"
doDldZip "Ignitetechnologies" "Mindmap" "main"

find . -type f -name ".DS_Store" -delete
find . -type f -name "LICENSE" -delete
find . -type f -name "LICENSE.*" -delete
find . -type f -name "CHANGELOG.*" -delete
