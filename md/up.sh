#!/bin/bash
function doDldZip {
  userName="$1"
  pName="$2"
  main="$3"
  wget -c --no-check-certificate -O "${pName}.zip" "https://github.com/${userName}/${pName}/archive/refs/heads/${main}.zip"
  unzip -x "${pName}.zip" && rm -rf "${pName}" && mv "${pName}-${main}" "${pName}" && rm -rf "${pName}.zip" "${pName}/.github" && git add "${pName}"
}


# data
wget -c -O ../data/chaos-bugbounty-list.json 'https://github.com/projectdiscovery/public-bugbounty-programs/raw/main/chaos-bugbounty-list.json'
wget -c -O ../data/DefaultCreds-Cheat-Sheet.csv https://github.com/ihebski/DefaultCreds-cheat-sheet/raw/main/DefaultCreds-Cheat-Sheet.csv
mkdir -p Intruder
wget -c -O Intruder/xss-payload-list.txt https://github.com/payloadbox/xss-payload-list/raw/master/Intruder/xss-payload-list.txt

# readme
wget -c -O CobaltStrike_BOF_Collections.md https://github.com/wsummerhill/C2_RedTeam_CheatSheets/raw/main/CobaltStrike/BOF_Collections.md
wget -c -O RedTeam_CheatSheet.md https://github.com/wsummerhill/C2_RedTeam_CheatSheets/raw/main/CobaltStrike/RedTeam_CheatSheet.md
wget -c -O WindowsPrivilegeEscalation.md https://github.com/ycdxsb/WindowsPrivilegeEscalation/raw/main/README.md
wget -c -O awesome-mac-zh.md https://github.com/jaywcjlove/awesome-mac/raw/master/README-zh.md
wget -c -O awesome-hacking.md https://github.com/carpedm20/awesome-hacking/raw/master/README.md
wget -c -O Awesome-Hacking-Resources.md https://github.com/vitalysim/Awesome-Hacking-Resources/raw/master/README.md
wget -c -O Awesome-Hacking-Resources-tools.md https://github.com/vitalysim/Awesome-Hacking-Resources/raw/master/tools.md
wget -c -O Awesome-Fuzzing_ch.md https://github.com/secfigo/Awesome-Fuzzing/raw/master/README_ch.md
wget -c -O Awesome-Fuzzing.md https://github.com/secfigo/Awesome-Fuzzing/raw/master/README.md
wget -c -O the-book-of-secret-knowledge.md https://github.com/trimstray/the-book-of-secret-knowledge/raw/master/README.md
wget -c -O awesome-bugbounty-tools.md https://github.com/vavkamil/awesome-bugbounty-tools/raw/main/README.md
wget -c -O Awesome-Bugbounty-Writeups.md https://github.com/devanshbatham/Awesome-Bugbounty-Writeups/raw/master/README.md
wget -c -O A-Red-Teamer-diaries.md https://github.com/ihebski/A-Red-Teamer-diaries/raw/master/README.md
wget -c -O study-bug-bounty.md https://github.com/bobby-lin/study-bug-bounty/raw/master/README.md
wget -c -O djadmin-awesome-bug-bounty.md https://github.com/djadmin/awesome-bug-bounty/raw/master/README.md
wget -c -O awesome-hacker-search-engines.md https://github.com/edoardottt/awesome-hacker-search-engines/raw/main/README.md
wget -c -O awesome-oneliner-bugbounty.md https://github.com/dwisiswant0/awesome-oneliner-bugbounty/raw/master/README.md
wget -c -O Ignitetechnologies-bugbounty.md https://github.com/Ignitetechnologies/bugbounty/raw/main/README.md
wget -c -O xss-payload-list.md https://github.com/payloadbox/xss-payload-list/raw/master/README.md
wget -c -O 渗透常用命令command.md https://github.com/safe6Sec/command/raw/master/README.md
wget -c -O kali-linux-cheatsheet.md https://github.com/NoorQureshi/kali-linux-cheatsheet/raw/master/README.md
wget -c -O Awesome-Hacking.md https://github.com/Hack-with-Github/Awesome-Hacking/raw/master/README.md
wget -c https://raw.githubusercontent.com/hktalent/myhktools/main/tools/webPenTest.md
wget -c https://raw.githubusercontent.com/hktalent/myhktools/main/tools/Awesome_Penetration_Testing-command-line.md
wget -c -O myhktools-command-line.md https://github.com/hktalent/myhktools/blob/main/tools/README.md
wget -c https://github.com/hktalent/myhktools/raw/main/tools/awesome-macos-command-line.md
wget -c -O key_hacks.md https://github.com/streaak/keyhacks/raw/master/README.md
wget -c -O AD-Pentest-Notes内网渗透学习笔记.md https://github.com/chriskaliX/AD-Pentest-Notes/raw/master/README.md

wget -c -O awesome-chatgpt-prompts.csv https://github.com/f/awesome-chatgpt-prompts/raw/main/prompts.csv
# md
# ssh-keys
# https://github.com/ihebski/DefaultCreds-cheat-sheet/
# cat bugbounty-cheatsheet.txt|xargs -I % proxychains4 -f /Users/51pwn/MyWork/for_hacker_md/v2ray51pwn/proxychains.conf  wget -c -O bugbounty-cheatsheet-% https://github.com/EdOverflow/bugbounty-cheatsheet/raw/master/cheatsheets/%
cat bugbounty-cheatsheet.txt|xargs -I % wget -c -O bugbounty-cheatsheet-% https://github.com/EdOverflow/bugbounty-cheatsheet/raw/master/cheatsheets/%


doDldZip "daffainfo" "AllAboutBugBounty" "master"
# gh repo clone swisskyrepo/PayloadsAllTheThings
doDldZip "swisskyrepo" "PayloadsAllTheThings" "master"
doDldZip "lutfumertceylan" "top25-parameter" "master"
doDldZip "LandGrey" "SpringBootVulExploit" "master"
doDldZip "1N3" "Sn1per" "master"
doDldZip "1N3" "BruteX" "master"
doDldZip "1N3" "Findsploit" "master"
doDldZip "nahamsec" "Resources-for-Beginner-Bug-Bounty-Hunters" "master"
doDldZip "Jack-Liang" "kalitools" "master"
doDldZip "proudwind" "javasec_study" "master"
doDldZip "reddelexc" "hackerone-reports" "master"
doDldZip "helloexp" "0day" "master"
doDldZip "gwen001" "pentest-tools" "master"
doDldZip "Rhynorater" "CVE-2018-15473-Exploit" "master"
doDldZip "EdOverflow" "can-i-take-over-xyz" "master"
doDldZip "nidem" "kerberoast" "master"
doDldZip "KingOfBugbounty" "KingOfBugBountyTips" "master"
doDldZip "gobysec" "GobyVuls" "master"

doDldZip "microsoft" "Security-101" "main"
doDldZip "FDlucifer" "Proxy-Attackchain" "main"
doDldZip "reidmu" "sec-note" "main"
doDldZip "0xsyr0" "OSCP" "main"
doDldZip "0xsyr0" "Awesome-Cybersecurity-Handbooks" "main"
doDldZip "aufzayed" "bugbounty" "main"
doDldZip "0xmaximus" "Galaxy-Bugbounty-Checklist" "main"
doDldZip "akr3ch" "BugBountyBooks" "main"
# https://github.com/arkadiyt/bounty-targets
doDldZip "arkadiyt" "bounty-targets-data" "main"
doDldZip "Osb0rn3" "bugbounty-targets" "main"
doDldZip "Ignitetechnologies" "Mindmap" "main"
doDldZip "0xn3va" "cheat-sheets" "main"
doDldZip "DawnFlame" "POChouse" "main"


find . -type f -name ".DS_Store" -delete
find . -type f -name "LICENSE" -delete
find . -type f -name "LICENSE.*" -delete
find . -type f -name "CHANGELOG.*" -delete
find .. -name "*.py.zip" -delete 


