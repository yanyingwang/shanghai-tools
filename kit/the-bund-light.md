The Bund light/外滩之光
==============

This bash script is usefull for you, if you have heard of 'caffeine' or 'lightsOn.sh' and is using Ubuntu system.  
I've test this script on my Ubuntu 14.10 system.  
For how to use it, Please check installation part.  



# 原因
如果你听说过'caffeine'或者'lightsOn.sh'这两个东西，那么这个脚本或许对你是有用的。  
我写这个脚本的原因是因为Chrome或者fixfox在Ubuntu下面如果全屏观看flash类的视频，系统的屏幕保护程序仍然会运行。


# 作用
所以这个脚本的作用就是使Chrome或者fixfox在Ubuntu下面全屏观看flash类的视频的时候，使屏幕保护程序不会被自动激活。  
实际上，这个脚本目前会检测所有的应用程序，如果有应用程序在全屏运行，那么屏幕保护程序则不会被自动激活。

# installion/安装
```
sudo apt-get install xdottool
```

add code below to `/etc/rc.local`file before `exit 0`.
```
BUND=$HOME/shanghai-tools/kit/the-bund-light.sh  # the path where you put this script in
test -x $BUND && \
    ($BUND &> /var/log/thebundlight.log &)
```

# 注意：
此脚本是基于Ubuntu系统而写，我仅在我的本机Ubuntu 14.10上面做过测试。



