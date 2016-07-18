http://lbsyun.baidu.com/index.php?title=iossdk/guide/buildproject
概述

百度地图iOS SDK自v2.7.0版本起，向广大开发者提供了 .framework形式的SDK开发包，这种形式的开发包配置简单，使用方便，推荐大家使用。
注：由于iOS9改用更安全的https，为了能够在iOS9中正常使用地图SDK，请在"Info.plist"中进行如下配置，否则影响SDK的使用。
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
自动配置.framework形式开发包（使用CocoaPods）

注：此种方式只支持导入全量包的SDK，包含百度地图iOS SDK所有功能
一、前提：安装CocoaPods
在终端输入
sudo gem install cocoapods
如果安装成功，会有一个提示
Successfully installed cocoaPods
二、使用CocoaPods导入地图SDK
在当前工程文件（.xcodeproj）所在文件夹下，打开terminal
1.创建Podfile：
touch Podfile
2.编辑Podfile内容如下：
pod 'BaiduMapKit' #百度地图SDK
3.在Podfile所在的文件夹下输入命令：
pod install （这个可能比较慢，请耐心等待……）
成功以后，会出现如下记录：
Analyzing dependencies

Downloading dependencies

Installing BaiduMapKit (2.9.1)

Generating Pods project

Integrating client project

[!] Please close any current Xcode sessions and use `***.xcworkspace` for this project from now on.
Sending stats
恭喜你已成功导入百度地图iOS SDK，现在就可以打开xcworkspace文件，在你的项目中使用百度地图SDK了
手动配置.framework形式开发包

第一步、根据需要导入 .framework包
百度地图 iOS SDK 采用分包的形式提供 .framework包，请广大开发者使用时确保各分包的版本保持一致。其中BaiduMapAPI_Base.framework为基础包，使用SDK任何功能都需导入，其他分包可按需导入。
将所需的BaiduMapAPI_**.framework拷贝到工程所在文件夹下。
在 TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，在弹出的窗口中点击“Add Other”按钮，选择BaiduMapAPI_**.framework添加到工程中。
注: 静态库中采用Objective-C++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)，或者在工程属性中指定编译方式，即在Xcode的Project -> Edit Active Target -> Build Setting 中找到 Compile Sources As，并将其设置为"Objective-C++"

第二步、引入所需的系统库
百度地图SDK中提供了定位功能和动画效果，v2.0.0版本开始使用OpenGL渲染，因此您需要在您的Xcode工程中引入CoreLocation.framework和QuartzCore.framework、OpenGLES.framework、SystemConfiguration.framework、CoreGraphics.framework、Security.framework、libsqlite3.0.tbd（xcode7以前为 libsqlite3.0.dylib）、CoreTelephony.framework 、libstdc++.6.0.9.tbd（xcode7以前为libstdc++.6.0.9.dylib）。
（注：红色标识的系统库为v2.9.0新增的系统库，使用v2.9.0及以上版本的地图SDK，务必增加导入这3个系统库。）
添加方式：在Xcode的Project -> Active Target ->Build Phases ->Link Binary With Libraries，添加这几个系统库即可。

第三步、环境配置
在TARGETS->Build Settings->Other Linker Flags 中添加-ObjC。

第四步、引入mapapi.bundle资源文件
如果使用了基础地图功能，需要添加该资源，否则地图不能正常显示mapapi.bundle中存储了定位、默认大头针标注View及路线关键点的资源图片，还存储了矢量地图绘制必需的资源文件。如果您不需要使用内置的图片显示功能，则可以删除bundle文件中的image文件夹。您也可以根据具体需求任意替换或删除该bundle中image文件夹的图片文件。
方法：选中工程名，在右键菜单中选择Add Files to “工程名”…，从BaiduMapAPI_Map.framework||Resources文件中选择mapapi.bundle文件，并勾选“Copy items if needed”复选框，单击“Add”按钮，将资源文件添加到工程中。

第五步、引入头文件
在使用SDK的类 按需 引入下边的头文件：
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import < BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件