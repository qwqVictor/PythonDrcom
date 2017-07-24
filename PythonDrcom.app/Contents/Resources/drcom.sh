#!/bin/sh
rspx=`echo $0`
rsp=${rspx%%'/drcom.sh'*}

function login_unsaved {
	echo "IP地址是固定的还是 DHCP 随机的？(固定/DHCP)"
	read ipconf
	#cd $rsp
	case $ipconf in
		"固定" )
			sh $rsp/GenerateConf.sh stip
			cat /tmp/drcom_homeip.conf > /tmp/drcom_ip
			;;
		"DHCP" )
			/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6 | awk '{print $2}' | tr -d "addr:" > /tmp/ip
			export ThisIP_drcom=`echo "host_ip = '" && head -n 1 /tmp/ip && echo "'"`
			rm /tmp/ip
			echo $ThisIP_drcom
			echo $ThisIP_drcom > /tmp/drcom_ip
			echo >> /tmp/drcom_ip
			sh $rsp/GenerateConf.sh dhcp
			;;
		"dhcp" )
			/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6 | awk '{print $2}' | tr -d "addr:" > /tmp/ip
			export ThisIP_drcom=`echo "host_ip = '" && head -n 1 /tmp/ip && echo "'"`
			rm /tmp/ip
			echo $ThisIP_drcom
			echo $ThisIP_drcom > /tmp/drcom_ip
			echo >> /tmp/drcom_ip
			sh $rsp/GenerateConf.sh dhcp
			;;
	esac
	cat $rsp/drcom.conf /tmp/drcom_user.conf /tmp/drcom_ip $rsp/latest-wired.py > /tmp/Drcom.py
	echo "Dr.COM 已经运行，请勿关闭终端。若要退出请按两次 Control+C 键"
	python /tmp/Drcom.py > /dev/null
	echo "Dr.COM 已经注销！"
	read -sn 1
	rm /tmp/drcom_user.conf /tmp/drcom_homeip.conf /tmp/drcom.conf /tmp/Drcom.py /tmp/drcom_ip
}

function login_saved {
	if [ -f ~/Library/Application\ Support/org.chick.drcom/user/drcom_user.conf ]; then
		echo "IP地址是固定的还是 DHCP 随机的？(固定/DHCP)"
		read ipconf
		#cd $rsp
		case $ipconf in
			"固定" )
				cat ~/Library/Application\ Support/org.chick.drcom/user/drcom_homeip.conf > /tmp/drcom_ip
				;;
			"DHCP" )
				/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6 | awk '{print $2}' | tr -d "addr:" > /tmp/ip
				export ThisIP_drcom=`echo "host_ip = '" && head -n 1 /tmp/ip && echo "'"`
				rm /tmp/ip
				echo $ThisIP_drcom
				echo $ThisIP_drcom > /tmp/drcom_ip
				echo >> /tmp/drcom_ip
				;;
			"dhcp" )
				/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6 | awk '{print $2}' | tr -d "addr:" > /tmp/ip
				export ThisIP_drcom=`echo "host_ip = '" && head -n 1 /tmp/ip && echo "'"`
				rm /tmp/ip
				echo $ThisIP_drcom
				echo $ThisIP_drcom > /tmp/drcom_ip
				echo >> /tmp/drcom_ip
				;;
		esac
		cat $rsp/drcom.conf ~/Library/Application\ Support/org.chick.drcom/user/drcom_user.conf /tmp/drcom_ip $rsp/latest-wired.py > /tmp/Drcom.py
		echo "Dr.COM 已经运行，请勿关闭终端。若要退出请按两次 Control+C 键"
		python /tmp/Drcom.py > /dev/null
		echo "Dr.COM 已经注销！"
		read -sn 1
		rm /tmp/drcom_user.conf /tmp/drcom_homeip.conf /tmp/drcom.conf /tmp/Drcom.py /tmp/drcom_ip
	else
		echo "没有已保存的配置，请返回主菜单并生成配置！"
		echo "按任意键返回主菜单……"
		read -sn 1
	fi

}

function check_python {
	python --version
	read -sn 1
}

function generate_conf {
	sh $rsp/GenerateConf.sh
	read -sn 1
}

function edit_general_conf {
	nano $rsp/drcom.conf
}

function get_help {
	cp $rsp/help /tmp/help_drcom
	nano /tmp/help_drcom
	rm /tmp/help_drcom
}

function menu {
	echo "欢迎使用 PythonDrcom！"
	echo
	echo "1. 使用已保存的配置登录"
	echo "2. 临时登录"
	echo "3. 生成配置"
	echo "4. 检测 Python 环境"
	echo "5. 帮助"
	echo "6. 修改总配置"
	echo "7. 退出程序"
	echo
	echo "Code with ❤  by @凌风仙鸡<me@chickger.pw>"
	echo "Follow Me at: https://chickger.pw/"
	echo
	echo "请输入指令: "
	read -n1 option
	echo
	echo
	case $option in
		"1" )
			login_saved;;
		"2" )
			login_unsaved;;
		"3" )
			generate_conf;;
		"4" )
			check_python;;
		"5" )
			get_help;;
		"6" )
			edit_general_conf;;
		"7" )
			exit;;
		*   )
			echo "输入错误！按任意键返回主菜单……"
			read -sn 1
	esac
}
while [ 1 ]; do
clear
menu
done
