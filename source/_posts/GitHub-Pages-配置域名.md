title: GitHub Pages 配置域名
date: 2016-08-25 12:37:31
categories:
tags:
---


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/githubpages1.png)
可以填www
也可以不填
也可以填其他你想要的词
例如
主机记录填 www
意思就是访问 www.jianfeiyizhan.com是有效的指向你设置的记录值的.
主机记录不填或者填@
意思就是访问 jianfeiyizhan.com是指向你记录值的.
你也可以设置泛解析 主机记录填 *
这样 任何值.jianfeiyizhan.com都指向你设置的记录值
#Github Page种类
1. UserPage: 用户的整个站点, 这个是最出github支持的类型, 创建一个形如username.github.com的项目就可以

ProjectPage: 用户创建出来的项目也可以创建站点, 创建一个项目后, 在建立一个名叫gh-pages的branch, 这个branch里的文件就是page的站点文件
#UserPage默认域名

用户站点的默认域名是username.github.io, 比如笔者的站点就是liang8305.github.io

#ProjectPage默认域名

项目的默认域名, 是使用UserPage域名加上二级目录实现的, 比如笔者有个项目叫cydia, 那么该项目的站点就是访问 liang8305.github.io/cydia

#UserPage自定义域名

我有自己的域名, 如何绑定到UserPage? 比如用www.zhaoxiaodan.com替代liang8305.github.io他是使用CNAME技术来实现的

具体步骤:

去域名注册商那里, 做一个CNAME指向, 将www.zhaoxiaodan.com 指向 liang8305.github.io,

在liang8305/liang8305.github.com这个项目(也就是page项目)根目录下建一个CNAME文件, 里面填写www.zhaoxiaodan.com, 然后提交到仓库;

等10分钟

CNAME指向之后, 当浏览器访问www.zhaoxiaodan.com的时候浏览器就知道实际上是访问liang8305.github.io 
添加CNAME 文件之后, 当GithubPage服务器接收到访问www.zhaoxiaodan.com的http请求, 就知道, 对应的是这个工程了

#ProjectPage自定义域名

比如用cydia.zhaoxiaodan.com替代liang8305.github.io/cydia

同样的, 去域名注册商那里, 做一个CNAME指向, 将cydia.zhaoxiaodan.com 指向 liang8305.github.io, 如果以后会有很多二级域名都指过来, 其实可以做一个模糊二级指过来, 比如*.zhaoxiaodan.com

在liang8305/cydia这个项目(也就是page项目)根目录下建一个CNAME文件, 里面填写cydia.zhaoxiaodan.com, 然后提交到仓库;

等10分钟


http://www.zhaoxiaodan.com/其他/如何配置GithubPage的二级域名.html