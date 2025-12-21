---
title: Swift 脚本编写
date: 2017-04-02 22:23:30
categories: iOS开发
tags: [swift, 脚本, 命令行]
description: 学习如何使用Swift编写命令行脚本，包括Hello World示例和执行shell命令的方法
keywords: Swift脚本,命令行,Shell执行,NSTask,Process
---




# Swift 脚本编写基础

## Hello World 示例

按照编程学习的传统，我们从 Hello World 开始。

创建一个名为 `Hello.swift` 的文件，输入以下内容：

```swift
#!/usr/bin/env xcrun swift
print("Hello World")
```

在终端中切换到文件所在目录，为脚本添加可执行权限：

```bash
chmod +x Hello.swift
```

运行脚本：

```bash
./Hello.swift
```

你将在终端看到熟悉的 "Hello World" 输出。

## 执行 Shell 脚本

在 Swift 脚本中，你可以充分利用 Swift 的语法特性。但有时候需要调用 shell 命令，这时可以使用 Foundation 框架中的 `Process` 类。

### 基本用法

首先导入 Foundation 框架：

```swift
import Foundation
```

### 执行简单命令

```swift
// 调用 shell 脚本的关键代码
let shell = "pwd"
let task = Process()
task.executableURL = URL(fileURLWithPath: "/bin/bash")
task.arguments = ["-c", shell]

do {
    try task.run()
} catch {
    print("执行失败: \(error)")
}
```

`shell` 变量可以是任何能在 bash 中执行的命令文本。
