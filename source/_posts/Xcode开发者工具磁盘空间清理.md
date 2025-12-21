---
title: Xcode开发者工具磁盘空间清理
date: 2016-08-15 15:50:10
categories: iOS SDK
tags:   
---

#Xcode磁盘空间大清理

使用[Daisy Disk](https://daisydiskapp.com)可以查看整个电脑的存储情况

##移除对旧设备的支持

每次把一个设备接入电脑进行真机调试之前，电脑会对设备建立索引，也在此文件夹下生成对该设备系统的支持文件。于是这里存在了一堆对旧版本iOS设备支持的文件。而我最近基本只对iOS9.3的设备进行真机调试。于是删除了所有低于9.3的文件夹。

路径：~/Library/Developer/Xcode/iOS DeviceSupport
<!-- more -->

##移除旧版本的模拟器支持


影响：不可恢复；如果需要旧版本的模拟器，就需要重新下载了。

路径：~/Library/Application Support/iPhone Simulator

##移除模拟器的临时文件

影响：可重新生成；如果需要保留较新版本的模拟器，但tmp文件夹很大。放心删吧，tmp文件夹里的内容是不重要的。在iOS Device中，存储空间不足时，tmp文件夹是可能被清空的。


路径：~/Library/Application Support/iPhone Simulator/8.0/tmp (以iOS Simulator 6.1为例)

##移除模拟器中安装的Apps

影响：不可恢复；对应的模拟器中安装的Apps被清空了，如果不需要就删了吧。

路径：~/Library/Application Support/iPhone Simulator/8.0/Applications (以iOS Simulator 为例)

#移除Archives

每次打包App的dSYM等数据就保存在这里，把一些没用的版本删了。如果是上线了的版本还是保留吧。

路径：~/Library/Developer/Xcode/Archives

##移除DerivedData


这个文件夹中保存的是Xcode的缓存文件，曾经在Xcode跑过的所有项目的索引、build的信息等都会保存在这里。删除后在下次打开项目编译的时候将会重新生成。由于这里包含了大量已经没用的项目的信息又懒得去筛选，于是把整个文件夹删了。

路径：~/Library/Developer/Xcode/DerivedData

##Products

路径: ~/Library/Developer/Xcode/Products/

同上，把没用的删了


##移除旧的Docsets

影响：不可恢复；将删除旧的Docsets文档

路径：~/Library/Developer/Shared/Documentation/DocSets

##CoreSimulator
 ~/Library/Developer/CoreSimulator/Devices/

一堆模拟器的数据。每个文件夹里包含的就是一个特定系统版本的设备的数据。每个文件夹对应哪个设备可以在其下device.plist中查看。亲测删除之后的效果跟在模拟器里重置相同。省得一个个去重置了，删吧。

##XCPGDevices
 ~/Library/Developer/XCPGDevices/

这里保存了playground的项目缓存。全删了
