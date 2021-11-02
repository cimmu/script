#!/bin/bash                                                                                               
#===================================================================#
#   Description: Install Docker for Linux                           #
#   Blog: https://7mu.top                                           #
#===================================================================#
#
#
#  ______  .___  ___.  __    __  .___________.  ______   .______   
# |____  | |   \/   | |  |  |  | |           | /  __  \  |   _  \  
#     / /  |  \  /  | |  |  |  | `---|  |----`|  |  |  | |  |_)  | 
#    / /   |  |\/|  | |  |  |  |     |  |     |  |  |  | |   ___/  
#   / /    |  |  |  | |  `--'  |  __ |  |     |  `--'  | |  |      
#  /_/     |__|  |__|  \______/  (__)|__|      \______/  | _|      
#                                                                      
#
#             
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#check root
[ $(id -u) != "0" ] && { echo "错误: 您必须以root用户运行此脚本"; exit 1; }

#工具安装
install_pack() {
    pack_name="wget未知"
    echo "===> Start to install curl"    
    if [ -x "$(command -v yum)" ]; then
        command -v curl > /dev/null || yum update -y && yum install -y curl
    elif [ -x "$(command -v apt)" ]; then
        command -v curl > /dev/null || apt update -y && apt install -y curl
    else
        echo "Package manager is not support this OS. Only support to use yum/apt."
        exit -1
    fi
    
}

# @安装docker
install_docker() {
    docker version > /dev/null || curl -fsSL get.docker.com | bash 
    service docker restart 
    systemctl enable docker  
}
install_docker_compose() {
	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
}

# 单独检测docker是否安装，否则执行安装docker。
check_docker() {
	if [ -x "$(command -v docker)" ]; then
		echo "您的系统已安装docker"
		# command
	else
		echo "开始安装docker。。。"
		# command
		install_docker        
	fi
}
check_docker_compose() {
	if [ -x "$(command -v docker-compose)" ]; then
		echo "docker-compose is installed"
        echo -e "\033[32m====================================\033[0m"	
        echo -e "\033[32m 系统已存在Docker环境                        "
        echo -e "\033[32m====================================\033[0m"
	else
		echo "Install docker-compose"
		# command
		install_docker_compose
	fi
}



#开始菜单
start_menu(){
    clear
	  echo "
 _______   ______     ______  __  ___  _______ .______      
|       \ /  __  \   /      ||  |/  / |   ____||   _  \     
|  .--.  |  |  |  | |  ,----'|  '  /  |  |__   |  |_)  |    
|  |  |  |  |  |  | |  |     |    <   |   __|  |      /     
|  '--'  |  `--'  | |  `----.|  .  \  |  |____ |  |\  \----.
|_______/ \______/   \______||__|\__\ |_______|| _| `._____|
                                                            
"
    echo -e "\033[43;42m =====================================\033[0m"
    echo -e "\033[43;42m 介绍：Docker一键安装脚本                \033[0m"
    echo -e "\033[43;42m 作者：柒慕科技                         \033[0m"
    echo -e "\033[43;42m 网站：https://7mu.top                 \033[0m"
    echo -e "\033[43;42m 适配：centos ubuntu debian            \033[0m"
    echo -e "\033[43;42m =====================================\033[0m"
    echo
    echo -e "\033[0;33m  确认请按回车键Enter；否则按Ctrl+C退出 \033[0m"
    echo
    read -p "是否继续？:" num
    case "$num" in   
    *)
    install_pack
	check_docker
    check_docker_compose
    echo -e "\033[32m====================================\033[0m"	
    echo -e "\033[32m 恭喜，您已经完成docker环境的安装                        "
    echo -e "\033[32m====================================\033[0m"	
	;;
    esac
}

start_menu
