#!/bin/bash


echo "------------------------------------------------------"
echo "Welcome To DebugZ-LAB-Server Synchronization Manager"
echo "------------------------------------------------------"
mega-session | grep -q ''
sleep 5

if mega-whoami | grep -q 'Not logged in';
then
login=true
while $login;
do               
echo -n "Please Enter Your Email On Mega : "

read -r email

echo -n "Please Enter Your Password On Mega : "
stty -echo
read -r password
stty echo
echo ""
if mega-login "$email" "$password" | grep -q 'API:err:';
then
echo "Username Or Password Is Incorrect (Try Again)"
continue
else
echo "Hello"
mega-login "$email" "$password"
break
fi
done

else
echo "-------------------------------------"
echo "You're Connected To Your Mega Account"
echo "-------------------------------------"
fi
mainDir='DLSRV Repos'
echo    "-----------------------------------------------"
echo    "Checking Your Server Synchronization Activation"
echo -n '#####                                   (10%)\r'
sleep 1
echo -n '#########                               (15%)\r'
sleep 1
echo -n '###########                             (20%)\r'
sleep 1
echo -n '#############                           (66%)\r'
sleep 1
echo -n '####################################   (100%)\r'
echo -n '\n'
if mega-ls ahmedrafat@debugz-it.com:"$mainDir" | grep -q "Couldn't find";
then
echo "Activation Status : Off (Can't Proceed) -- Contact DebugZ To Enable Activation --"
echo     "-----------------------------------------------"
exit
else
echo "Activation Status : on"
fi
echo     "-----------------------------------------------"

echo     "-----------------------------------------------"
echo     "Updating Your Docker Images"
echo -n  '#####                                   (10%)\r'
sleep 1
echo -n  '#########                               (15%)\r'
sleep 1
echo -n  '###########                             (20%)\r'
sleep 1
echo -n  '#############                           (66%)\r'
sleep 1
echo -n  '####################################   (100%)\r'
echo -n  '\n'
mkdir megaFiles
cd megaFiles
if ! docker images | grep -q 'IPerf-Docker';
then
mega-get https://mega.nz/file/BcoC3aib#Un4HOdrfROx2LIea2jZPFdgbVzpkXrXqfiV4R1lso_Y
docker image load -i IPerf-Docker
fi
cd
rm -rf megaFiles
echo     "-----------------------------------------------"

flag=true
while $flag;
do 
echo -n "Do You Want To Download LABs Or Addons (labs/addons) : "
read -r option1
if [ "$option1" = "labs" ] || [ "$option1" = "addons" ];
then
break
else
echo "You've Entered An Invalid Name (Try Again)"
fi
done
case $option1 in

labs)
while $flag ;
do 
mega-ls ahmedrafat@debugz-it.com:"$mainDir"/"$option1"
echo -n "Specify Folder Name You Wish To Download : "
read -r option2
if mega-ls ahmedrafat@debugz-it.com:"$mainDir"/"$option1" | grep -q "$option2" ;
then
mega-get ahmedrafat@debugz-it.com:"$mainDir"/"$option1"/"$option2" /opt/unetlab/labs
chown -R www-data:www-data /opt/unetlab/labs/
chmod 2755 -R /opt/unetlab/labs/
break
else 
echo "You've Entered An Invalid Name (Try Again)"
fi
done
;;

addons)
while $flag ;
do 
mega-ls ahmedrafat@debugz-it.com:"$mainDir"/"$option1"
echo -n "Specify Folder Name You Wish To Download : "
read -r option3
if mega-ls ahmedrafat@debugz-it.com:"$mainDir"/"$option1"/"$option3" | grep -q "$option3" ;
then
 if [ "$option3" = "qemu" ]; 
 then
 echo "----------------------------------------------------"
 echo "WARNING : YOU ARE TRYING TO DOWNLOAD A LARGE FOLDER"
 echo "----------------------------------------------------"
 while $flag ;
  echo -n "Do You Want To Complete Downloading (yes) Or Choosing A Specific Image (no) : "
  read -r answer1
 do
  if [ "$answer1" = "yes" ];
  then
  mega-get ahmedrafat@debugz-it.com:"$mainDir"/"$option1"/"$option3" /opt/unetlab/addons
  break
  elif [ "$answer1" = "no" ];
  then
  while $flag ;
  do
  mega-cd ahmedrafat@debugz-it.com:"$mainDir"/"$option1"/"$option3"
  mega-ls
  echo -n "Specify Image Name You Wish To Download : "
  read -r answer2
    if mega-ls | grep -q "$answer2";
    then
    mega-get "$answer2" /opt/unetlab/addons/qemu
    break
    else
    echo "You've Entered An Invalid Name (Try Again)"
    fi
  done
  break
  else
  echo "You've Entered An Invalid Answer (Try Again)"
  fi
  done
break
elif [ "$option3" = "dynamips" ] || [ "$option3" = "iol" ] ;
  then
  mega-cd ahmedrafat@debugz-it.com:"$mainDir"/"$option1"
  mega-get "$option3" /opt/unetlab/addons
  if [ "$option3" = "iol" ];
  then
  cd /opt/unetlab/addons/iol/bin
  python ioukeygen.py
  mv iourc.txt iourc
  fi
  break
else 
echo "You've Entered An Invalid Name (Try Again)"
fi
fi
done
;;
esac
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions
