# rbclipper Visual Studio 操作指南

## 前置准备

1. **安装 Visual Studio 2022**（或兼容版本）
   - 需要安装 "使用 C++ 的桌面开发" 工作负载
   - 确保已安装 Windows SDK

2. **确认项目文件位置**
   - 解决方案文件：`SketchUp Ruby C Extension Examples.sln`
   - rbclipper 项目已在解决方案中

## 操作步骤

### 步骤 1：打开解决方案

1. 双击 `SketchUp Ruby C Extension Examples.sln` 文件
2. 或在 Visual Studio 中选择：**文件 > 打开 > 项目/解决方案**
3. 选择 `SketchUp Ruby C Extension Examples.sln`

### 步骤 2：确认项目加载

在解决方案资源管理器中，你应该能看到：
- ✅ SUEX_HelloWorld
- ✅ SUEX_UsingSWIG
- ✅ **rbclipper** ← 新项目

如果看不到 rbclipper：
- 右键解决方案 → **添加 > 现有项目**
- 选择 `rbclipper\rbclipper.vcxproj`

### 步骤 3：选择编译配置

在 Visual Studio 顶部工具栏：

1. **配置下拉菜单**：选择编译模式
   - `Debug (2.7)` - 调试模式，Ruby 2.7
   - `Release (2.7)` - 发布模式，Ruby 2.7
   - `Debug (3.2)` - 调试模式，Ruby 3.2
   - `Release (3.2)` - 发布模式，Ruby 3.2

2. **平台下拉菜单**：选择 `x64`

### 步骤 4：设置启动项目（可选）

1. 右键 **rbclipper** 项目
2. 选择 **设为启动项目**

**注意**：如果只是想编译，不需要设置启动项目。

### 步骤 5：编译项目

**方法 1：快捷键**
- 按 `Ctrl + Shift + B` 编译整个解决方案
- 或按 `F7` 编译当前项目

**方法 2：菜单**
- **生成 > 生成解决方案**（编译所有项目）
- **生成 > 生成 rbclipper**（只编译 rbclipper）

**方法 3：右键菜单**
- 右键 **rbclipper** 项目
- 选择 **生成**

### 步骤 6：检查编译结果

编译成功后，输出文件位置：

```
项目根目录/
├── Debug (2.7)/
│   └── x64/
│       └── clipper.so       ← Ruby 2.7 Debug 版本
├── Release (2.7)/
│   └── x64/
│       └── clipper.so       ← Ruby 2.7 Release 版本
├── Debug (3.2)/
│   └── x64/
│       └── clipper.so       ← Ruby 3.2 Debug 版本
└── Release (3.2)/
    └── x64/
        └── clipper.so       ← Ruby 3.2 Release 版本
```

## 常见问题排查

### 问题 1：找不到 Ruby 头文件

**错误信息**：
```
fatal error C1083: 无法打开包括文件: "ruby.h": No such file or directory
```

**解决方案**：
1. 检查 `ThirdParty\include\ruby\2.7\win32_x64` 目录是否存在
2. 检查 `ThirdParty\include\ruby\3.2\win32_x64` 目录是否存在
3. 确认解决方案路径正确

### 问题 2：找不到 Ruby 库文件

**错误信息**：
```
error LNK2019: 无法解析的外部符号
```

**解决方案**：
1. 检查 `ThirdParty\lib\win32\x64-msvcrt-ruby270.lib` 是否存在（Ruby 2.7）
2. 检查 `ThirdParty\lib\win32\x64-ucrt-ruby320.lib` 是否存在（Ruby 3.2）

### 问题 3：链接错误 - Init_clipper 未导出

**错误信息**：
```
error LNK2001: 无法解析的外部符号 Init_clipper
```

**解决方案**：
1. 确认 `clipper.def` 文件存在
2. 检查 `rbclipper.vcxproj` 中是否引用了 `clipper.def`
3. 项目属性 → 链接器 → 输入 → 模块定义文件 → 应为 `.\clipper.def`

### 问题 4：C++ 编译错误

**错误信息**：
```
error C2039: 'xxx': 不是 'std' 的成员
```

**解决方案**：
1. 确认项目设置了 C++ 标准（应为 C++11）
2. 项目属性 → C/C++ → 语言 → C++ 语言标准 → 选择 "ISO C++11"

## 验证编译产物

编译完成后，验证生成的 `.so` 文件：

1. 检查文件大小（应该 > 100 KB）
2. 使用 Dependency Walker 检查依赖（可选）
3. 在 SketchUp 中测试加载（使用 `require 'clipper'`）

## 批量编译所有配置

如果要一次性编译所有配置：

1. **生成 > 批生成...**
2. 选择以下配置并勾选：
   - ✅ Debug (2.7)|x64
   - ✅ Release (2.7)|x64
   - ✅ Debug (3.2)|x64
   - ✅ Release (3.2)|x64
3. 点击 **生成**

## 调试配置（可选）

如果需要调试：

1. 项目属性 → **调试**
2. 命令：设置为 SketchUp 可执行文件路径
   ```
   $(ProgramW6432)\SketchUp\SketchUp 2017\SketchUp.exe
   ```
3. 命令参数：
   ```
   -RubyStartup "$(SolutionDir)Ruby\launch_sketchup.rb" -RubyStartupArg "$(Configuration):$(PlatformTarget)"
   ```

设置断点后，按 `F5` 启动调试，会自动启动 SketchUp 并加载扩展。

## 快速检查清单

在开始编译前，确认：

- [ ] Visual Studio 2022 已安装
- [ ] 解决方案文件已打开
- [ ] rbclipper 项目已加载
- [ ] 选择了正确的配置（Debug/Release 和 Ruby 版本）
- [ ] 平台选择为 x64
- [ ] ThirdParty 目录中的 Ruby 头文件和库文件存在

## 输出目录结构说明

编译后的文件结构：

```
SolutionDir/
├── Debug (2.7)\x64\clipper.so     # Ruby 2.7 Debug 版本
├── Release (2.7)\x64\clipper.so   # Ruby 2.7 Release 版本（推荐使用）
├── Debug (3.2)\x64\clipper.so     # Ruby 3.2 Debug 版本
└── Release (3.2)\x64\clipper.so   # Ruby 3.2 Release 版本（推荐使用）
```

**建议**：使用 Release 版本用于生产环境，Debug 版本用于开发调试。

