
# XcodePlugin 探讨 - MakeZL :)

### 11月28号 有幸直播插件开发:) 感谢录制好的视频 [视频地址下载](http://pan.baidu.com/s/1o6OX52M)



====
## 以下是内容

### 插件是什么，为什么需要插件？

#### Xcode插件的存放的目录
~/Library/Application Support/Developer/Shared/Xcode/Plug-ins

#### 关于Xcode插件的运行原理 引用 [onevcat Xcode 4 插件制作入门]
在Xcode启动的时候，Xcode将会寻找位于~/Library/Application Support/Developer/Shared/Xcode/Plug-ins文件夹中的后缀名为.xcplugin的bundle作为插件进行加载（运行其中的可执行文件），这就可以令我们光明正大合法合理地将我们的代码注入（虽然这个词有点不好听）Xcode.

另外值得一提的是，在 Xcode5+中， Apple 为了防止过期插件导致的在 Xcode 升级后 IDE 的崩溃，添加了一个 UUID 的检查机制。只有包含声明了适配 UUID，才能够被 Xcode 正确加载。上面那个项目中也包含了这方面的更详细的说明，可以参考。
##### 读取Xcode的DVTPlugInCompatibilityUUIDs
defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID
##### 批量更新XcodeUUIds，前提是插件曾经运行过。
find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add `defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`

### 参考文章
[Xcode 4 插件制作入门](http://www.onevcat.com/2013/02/xcode-plugin/)

[How To Create an Xcode Plugin](http://www.raywenderlich.com/94020/creating-an-xcode-plugin-part-1)

### 经典插件
[VVDocumenter-onevcat](https://github.com/onevcat/VVDocumenter-Xcode)

[XAlign-qfish](https://github.com/qfish/XAlign)

[KSImageNamed-ksuther](https://github.com/ksuther/KSImageNamed-Xcode)

### 还有很多好用的参考 -> cocoachina以前这篇文章
[cocoachina-那些不能错过的Xcode插件](http://www.cocoachina.com/industry/20130918/7022.html)
......

### <<<2015年的插件>>>

#### EReveal-In-GitHub [leancloud的智维同学~ 是个95后屌屌的] 通过当前项目快捷键定位到Github (我参考这个来做的)
[Reveal-In-GitHub-lzwjava](https://github.com/lzwjava/Reveal-In-GitHub)

#### ESJsonFormat-Xcode 将JSON格式化输出为模型的属性
[ESJsonFormat-EnjoySR](https://github.com/EnjoySR/ESJsonFormat-Xcode)

#### RTImageAssets [rickytan] 将@2x图片拖到Xcode自动生成@3x,@1x
[RTImageAssets-rickytan](https://github.com/rickytan/RTImageAssets)

#### ZLGotoSandbox [自己写的] 找到模拟器路径跳转到沙盒路径
[ZLGotoSandbox-MakeZL](https://github.com/MakeZL/ZLGotoSandboxPlugin)

#### ZLCheckFilePlugin-Xcode [自己写的] 优化用, 找到项目中没有引用的文件
[ZLCheckFilePlugin-MakeZL](https://github.com/MakeZL/ZLCheckFilePlugin-Xcode)
.......
### 还有很多就不一一列举了

### Xcode Headers
https://github.com/luisobo/Xcode-RuntimeHeaders

### 管理Xcode插件
https://github.com/supermarin/Alcatraz
#### 运行脚本安装Alcatraz
curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/deploy/Scripts/install.sh | sh


##-撸码 新建插件
1. 新建一个Xcode项目，选择OS X的Framework & Library，再选择里面的bundle
2. 输入文件的名称，在Bundle Extension的后缀名换成 xcplugin(xcodePlugin)
3. 在工程文件找到info.plist,配置: 3.1 `XC4Compatible = YES`, (XCode4的插件加载机制跟Xcode5+有不同), 3.2 `XCPluginHasUI = NO` 插件是否有用户界面
4. 来到Xcode BuildSettings,搜索:`Deployment` 配置:  4.1 `Deployment = YES`, 4.2 `installation build products location = ${HOME}`, 4.3 `intallation Directory = /Library/Application Support/Developer/Shared/Xcode/Plug-ins`, 4.4 `Skip Install = NO`

##-撸码 更改Xcode背景色

##-调试 打断点Xcode插件

##-撸码 插件模板

前往[Xcode-Plugin-Template](https://github.com/kattrali/Xcode-Plugin-Template)下载Xcode插件开发的模板。

将下载下来的template复制到 ~/Library/Developer/Xcode/Templates/Project Templates/Application Plug-in/Xcode5 Plugin.xctemplate文件夹中，如果没有对应的文件夹就自己手工创建一个。

重启Xcode，当你新建一个工程的时候就可以在OSX中看到一个Application Plug-in的选项，里面有一个Xcode Plug-in模板。

##-撸码 实现Cocoapod-List
对CocoaPods安装不太熟的同学，可以百度或者参考唐巧[这篇博客](http://blog.devtang.com/blog/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/)

#### 删除所有Alcatraz里面插件
rm -rf ~/Library/Application\ Support/Alcatraz

#### 删除Alcatraz插件
rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin
#### 删除所有插件
rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins

=====
=====
=====
=====
=====
=====
=====
=====
=====
=====
=====
=====
=====
=====
=====
[自己的Github](https://github.com/MakeZL) 欢迎朋友们提issue,star

##-小结 Xcode插件虽然好用，但任何东西都不能过渡依赖，有可能就会出现后续问题，比如这周我们公司更新了Mantle，String与Number类型 必须与接口一致。但是呢，用的好的插件真的可以节省很大程度的开发时间，今天时间不早就告一段落，我是磊子，我的QQ：120886865，欢迎交流，但我平时好像很忙的样子，要各种忙着装B看书，弹吉他，打羽毛球之类的，哈哈哈~ Thanks!