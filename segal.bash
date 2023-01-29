#!/bin/bash

#this action will install the nipe 
function Inst(){

sudo apt update

git clone https://github.com/htrgouvea/nipe && cd nipe

sudo cpan install Try::Tiny Config::Simple JSON

sudo perl nipe.pl install

sudo apt-get install sshpass
}

#this action will check if the nipe allready installed and if not will install it to be anonymous
if [ -d 'nipe' ]

then echo "nipe installed" && cd nipe && sudo perl nipe.pl start

else echo "nipe isnt installed"
Inst
fi

#this action below will give the user his ip and the country that will shown 
echo "your ip is"

curl ifconfig.me

echo

echo "your country is"

geoiplookup read curl ifconfig.me | awk '{print($5 $6)}'

#checking if you are anonymous

function nipe(){
P=$(curl -s ifconfig.me)
if [[ $(geoiplookup $P | awk '{print $(NF5)}') == "IL" ]]
then echo "You are not anonymous" cd nipe && sudo perl nipe.pl restart
else echo "You are anonymous, continue to ssh" | lolcat -a -d 50 
fi
}
nipe

#the user enter  details to connect throw ssh
echo "write your username"

read admin

echo "what is your password"

read password

echo "write your ip"

read ip


echo "what ip target would you like to scan"

#all the info will be save into a file 
read target

function sshpasscon(){
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "curl -s ifconfig.io/country_code > country"
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "cat country" | tail -n 50 >> country.sh
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "whois $target > whois.sh"
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "cat whois.sh" | tail -n 50 >> whois.sh
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "uptime > uptime.sh"
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "cat uptime.sh" | tail -n 50 >> uptime
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "nmap $target > nmap.sh"
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "cat nmap.sh" | tail -n 150 >> nmap.sh
}
sshpasscon

echo "this is the ip $ip which connected" >> info.txt  
echo "this is the country $(cat country.sh) " >> info.txt
echo "your time of the $ip is $(cat uptime.sh)" >> info.txt
echo "your user is $(cat whois.sh)" >> info.txt
echo "the nmap report of $target are $(cat nmap.sh)" >> info.txt
echo "all will be save at info.sh file"

cat info.sh


