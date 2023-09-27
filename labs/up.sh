#!/bin/bash
function doDldZip {
  userName="$1"
  pName="$2"
  main="$3"
  wget -c -O "${pName}.zip" "https://github.com/${userName}/${pName}/archive/refs/heads/${main}.zip"
  unzip -x -o "${pName}.zip" && rm -rf "${pName}" && mv "${pName}-${main}" "${pName}" && rm -rf "${pName}.zip" "${pName}/.github" && git add "${pName}"
}

doDldZip "ZeddYu" "HTTP-Smuggling-Lab" "master"
doDldZip "knqyf263" "CVE-2021-40346" "main"
