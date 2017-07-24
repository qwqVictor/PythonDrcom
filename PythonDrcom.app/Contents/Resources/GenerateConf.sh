#!/bin/sh
if [ x$1 != x ]
then
	echo "用户名: "
	read username
	echo "密码: "
	read -s password
	if [[ $1 == "stip" ]]; then
		echo "固定 IP 地址:"
		read host_ip
		echo "host_ip = '$host_ip'" > /tmp/drcom_homeip.conf
		echo >> /tmp/drcom_homeip.conf
	fi
	echo "username = '$username'" > /tmp/drcom_user.conf
	echo >> /tmp/drcom_user.conf
	echo "password = '$password'" >> /tmp/drcom_user.conf
	echo "是否要保存配置(Y/N):"
	read -n1 savepz
	echo
	case $savepz in
		"Y"|"y" )
			cp /tmp/drcom_user.conf ~/Library/Application\ Support/org.chick.drcom/user/drcom_user.conf
			if [[ $1 != "stip" ]]; then
				echo "固定 IP 地址:"
				read host_ip
				echo "host_ip = '$host_ip'" > ~/Library/Application\ Support/org.chick.drcom/user/drcom_homeip.conf
				echo >> ~/Library/Application\ Support/org.chick.drcom/user/drcom_homeip.conf
			else
				cp /tmp/drcom_homeip.conf ~/Library/Application\ Support/org.chick.drcom/user/drcom_homeip.conf
			fi
			;;
		* )
			;;
	esac
else
	echo "欢迎使用 Dr.com 配置生成器，下一步将会删除当前已经保存的配置，若您不希望继续执行，请按下 Control-C 来直接退出程序。"
	echo "按任意键继续……"
	read -sn 1
	rm -rf ~/Library/Application\ Support/org.chick.drcom
	mkdir ~/Library/Application\ Support/org.chick.drcom/
	mkdir ~/Library/Application\ Support/org.chick.drcom/user/
	echo "用户名: "
	read username
	echo "密码: "
	read -s password
	echo "固定 IP 地址(若无固定 IP 请输入 0.0.0.0):"
	read host_ip
	echo
	echo "您的配置如下: "
	echo "用户名: "$username
	echo "密码: "$password
	echo "IP 地址: "$host_ip
	echo
	read -p "确认无误吗，确认无误吗? (Y/N)" savepz
	if [[ savepz == "Y"|"y" ]]; then
		echo "username = '$username'" > ~/Library/Application\ Support/org.chick.drcom/user/drcom_user.conf
		echo >> ~/Library/Application\ Support/org.chick.drcom/user/drcom_user.conf
		echo "password = '$password'" >> ~/Library/Application\ Support/org.chick.drcom/user/drcom_user.conf
		echo "host_ip = '$host_ip'" > ~/Library/Application\ Support/org.chick.drcom/user/drcom_homeip.conf
		echo >> ~/Library/Application\ Support/org.chick.drcom/user/drcom_homeip.conf
		echo "配置生成成功！"	
	else
		echo "返回主菜单！"
		read -sn 1
	fi

fi
