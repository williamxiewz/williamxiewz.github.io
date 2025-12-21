---
title: iOS 定位以及地图应用
date: 2016-08-21 19:18:05
categories: iOS SDK 
tags:  [MapKit,CoreLocation]
---

#定位服务

现在的移动设备大多都提供定位服务功能，使用iOS系统的iPhone,iPod touch和iPad 
都可以提供位置服务，iOS设备能提供3种不同途径进行定位:

- WiFi定位：通过査饰一个wiFi路th器的地理位置的信息，比较省电。iPhoneiPod touch和ipad都可以采用。 

- 蜂窝式移动电活基站定位：通过移动运用商基站定位。只有iPhone,3G版本的 
iPod touch和iPad可以采用。 

- GPS卫星定位：通过3〜4颗GPS卫星定位，最为准确，但是耗电量大，不能遮挡。 iPhone,iPod Touch和iPad都可以采用。 

- iBeacon微定位：苹果公司在iOS 7开始支持iBeacon技术，iBeacon技术是苹果研 
发,它使用低功耗蓝牙技术，通过多个iBeacon基站可以创建一个信号区域（地理围 
栏) 设备进入该区域时，相应的应用程序便会提示用户进入了这个地理围栏。 


>iOS不像Android系统在定位服务编程时候，可以指定采用哪种途径进行定位。iOS的API把底层这些细节屏蔽掉了，开发人员和用户并不知道现在设备采用哪种方式进行定位,
iOS系统会根据设备的情况和周圃的环境，采用一套最佳的解决方案。这个方案是这样:如果能够接收GPS信息，那么设备优先采用GPS定位，否则采用WiFi或蜂窝基站定位。在WiFi和蜂窝基站之间优先使用WiFi，如果无法连接WiFi才使用蜂窝基站定位。

<!-- more -->

##CoreLocation 



#地图服务



##MapKit



#Xcode Resource 

##GPX File 

[GPX档案格式](https://zh.wikipedia.org/zh-cn/GPX)（GPS Exchange Format）是XML格式的一种，专门用来储存地理资讯。 一个GPX档案当中可能包含一些路点（`waypoint`）及一些轨迹点（`trackpoint`）。 以全球定位系统（GPS装置）所产生的GPX档为例， 路点可能是各自独立互不相干的重要标记点， 例如照相的地点或使用者手动标记的休息站或路口等等；至于GPS装置自动定时记录的则是轨迹点。 有顺序的一串轨迹点构成一个轨迹（`track`）或者路程（`route`）。轨迹是一个人曾经走过的记录，可能包含走错的路等等；路程则经常是建议未来用路人可以走的路径。所以，一般来讲，轨迹里的点，包含时间信息，路程里的点，则没有时间信息。

GPX文件内的点，至少要包含经纬度座标两项资讯；其它字段都是可有可无的。

```swift
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" creator="MyGeoPosition.com" version="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
  <wpt lat="23.0920790" lon="113.3010790">
    <name>中国广州市海珠区滨江路中山大学 邮政编码: 510305</name>
    <src>MyGeoPosition.com</src>
    <link>http://mygeoposition.com</link>
  </wpt>
</gpx>
```

`<wpt>`标签中的`lat`属性设置纬度,`lon`属性设置经度。一般使用[www.mygeoposition.com](https://www.mygeoposition.com)网站提供的GPX工具.这个网站免费提供地理信息编码和反编码,生成KML和GPX文件等服务.

可以在KML/GPX 标签下载KML文件或者GPX文件.

>使用方法:
- 选择Shceme> Run >Options>Default Location > Add GPX File tp Project 
- 运行项目> Debug Area > Arrow > Add GPX File tp Project 


##GeoJSON File

GeoJSON是一种对各种地理数据结构进行编码的格式。GeoJSON对象可以表示几何、特征或者特征集合。GeoJSON支持下面几何类型：点、线、面、多点、多线、多面和几何集合。GeoJSON里的特征包含一个几何对象和其他属性，特征集合表示一系列特征。

一个完整的GeoJSON数据结构总是一个（JSON术语里的）对象。在GeoJSON里，对象由名/值对--也称作成员的集合组成。对每个成员来说，名字总是字符串。成员的值要么是字符串、数字、对象、数组，要么是下面文本常量中的一个："true","false"和"null"。数组是由值是上面所说的元素组成。

[GeoJSON格式规范说明](http://www.oschina.net/translate/geojson-spec?cmp)

###Geojson使用

最近AppStore在上传新应用的时候对于地图类的应用需要上传一个.geojson格式的文件，该文件是对区域作限制的文件，只有在该文件中规定的区域范围内才能下载该应用，否则是不能下载该应用的。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgeojson1.png)

那问题来了，如何才能生成该格式的问价呢?下面我们来看一下如何生成该格式的文件
和创建viewcontroller文件方式相同，右键new File 选择Resource第一个就是我们需要的文件如下图。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgeojson2.png)

创建完成后需要在文件中设置支持下载的区域的经纬度坐标，如下：

```bash
{
   "type": "MultiPolygon",
   "coordinates": [
                  [[ [55.06, 55.67], [152.51, 55.67], [152.51, 8.2], [55.06, 8.2], [55.06, 55.67] ]]
                  ]
}
```
　　注意：
　　(1)坐标位置第一个和最后一个必须相同，在这些坐标围成的区域是有效部分。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgeojson3.jpg)

　　(2)创建geojson文件的时候，文件名必须使用系统默认创建的文件名
