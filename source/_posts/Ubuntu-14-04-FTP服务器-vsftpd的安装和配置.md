---
title: Ubuntu 14.04 FTP服务器--vsftpd的安装和配置
date: 2016-10-20 10:20:07
categories: cloud computing
tags: [Cloud Computing,Ubuntu]
---
更新源列表
sudo apt-get update

安装vsftpd
sudo apt-get install vsftpd
判断vsftpd是否安装成功
sudo service vsftpd restart
<!-- more -->
新建"/home/vsftp"目录作为用户主目录
sudo mkdir /home/vsftp
sudo ls /home
新建用户user并设置密码
sudo useradd -d /home/user -s /bin/bash user

sudo passwd uftp
修改配置文件/etc/vsftpd.conf
sudo vim /etc/vsftpd.conf

添加
userlist_deny=NO
userlist_enable=YES userlist_file=/etc/allowed_users
修改
seccomp_sandbox=NO -> seccomp_sandbox=YES

新建/etc/allowed_users,输入user
sudo vim /etc/allowed_users

查看/etc/ftpusers,这个文件中记录的是不能访问FTP服务器的用户清单。
sudo vim /etc/ftpusers
