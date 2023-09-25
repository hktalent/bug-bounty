```
cat ./bounty-targets-data/data/hackerone_data.json|jq '.[].targets.in_scope[].asset_identifier'|grep -E '\*|https:\/\/'|grep -E "\*\."|tr ', ' '\n'|tr -d '"' |sort -u
```
