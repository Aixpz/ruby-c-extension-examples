# rbclipper Windows 编译规划 (Ruby 2.7 & 3.2)

## 概述
为 SketchUp Ruby 2.7 和 3.2 版本在 Windows Visual Studio 中编译 rbclipper gem 扩展。

## 文件结构
```
rbclipper/
├── rbclipper.vcxproj          # Visual Studio 项目文件
├── rbclipper.vcxproj.filters  # 文件分组
├── clipper.def                # 导出 Init_clipper 符号
└── src/
    ├── rbclipper.cpp          # Ruby 绑定 (530行)
    ├── clipper.cpp            # Clipper 库实现 (4629行)
    └── clipper.hpp            # Clipper 头文件 (406行)
```

## 编译配置要点

### 1. 项目配置
- **项目名**: `rbclipper`
- **Init 函数**: `Init_clipper()` (在 rbclipper.cpp:453)
- **输出文件名**: `clipper.so` (Windows SketchUp 使用 .so)
- **配置**: Debug/Release for Ruby 2.7 和 3.2 (x64 only)

### 2. 必需配置
- **C++ 语言标准**: C++11 或更高 (clipper.hpp 需要)
- **运行库**: `/MT` (MultiThreaded) - 与 SketchUp 兼容
- **字符集**: Unicode
- **平台工具集**: v143 (Visual Studio 2022)

### 3. 头文件路径
- `$(SolutionDir)ThirdParty\include\ruby\2.7\win32_x64` (Ruby 2.7)
- `$(SolutionDir)ThirdParty\include\ruby\3.2\win32_x64` (Ruby 3.2)
- `$(ProjectDir)src` (clipper.hpp 所在目录)

### 4. 库文件
- Ruby 2.7: `x64-msvcrt-ruby270.lib`
- Ruby 3.2: `x64-ucrt-ruby320.lib`
- 库路径: `$(SolutionDir)ThirdParty\lib\win32`

### 5. 预处理器定义
- `WIN32`
- `_WINDOWS`
- `_USRDLL`
- `_DEBUG` (Debug 配置) 或 `NDEBUG` (Release 配置)

## 实施步骤

### 步骤 1: 创建项目目录和源文件
1. 复制 gem 中的源文件到项目目录
2. 创建 `rbclipper/` 目录
3. 复制 `ext/clipper/` 下的所有 .cpp 和 .hpp 到 `src/`

### 步骤 2: 创建 .def 文件
创建 `clipper.def`，内容：
```
LIBRARY

EXPORTS
    Init_clipper
```

### 步骤 3: 创建 .vcxproj 文件
基于 `Hello World/Hello World.vcxproj` 模板：
- 修改项目名和 GUID
- 添加 rbclipper.cpp 和 clipper.cpp 源文件
- 配置为 C++ 项目（使用 C++ 编译器）
- 设置输出为 `clipper.so`
- 导入 Ruby 2.7 和 3.2 的 props 文件

### 步骤 4: 添加到解决方案
在 `SketchUp Ruby C Extension Examples.sln` 中添加新项目

### 步骤 5: 配置属性表
- 使用现有的 `Ruby 2.7 (x64).props` 和 `Ruby 3.2 (x64).props`
- 确保包含目录包含 `src` 目录

## 注意事项

1. **C++ 编译**: rbclipper 使用 C++，需要设置编译器为 C++，使用 `CONFIG['LDSHARED'] = "$(CXX) -shared"`

2. **命名空间**: rbclipper.cpp 使用 `using namespace ClipperLib`，确保 clipper.hpp 先被包含

3. **兼容性**: 
   - Ruby 2.7 使用 MSVCRT
   - Ruby 3.2 使用 UCRT
   - 确保运行时库设置正确

4. **输出路径**: 
   - Debug: `Debug (2.7)\x64\clipper.so` 和 `Debug (3.2)\x64\clipper.so`
   - Release: `Release (2.7)\x64\clipper.so` 和 `Release (3.2)\x64\clipper.so`

## 快速检查清单

- [ ] 创建 rbclipper 项目目录
- [ ] 复制源文件 (rbclipper.cpp, clipper.cpp, clipper.hpp)
- [ ] 创建 clipper.def
- [ ] 创建 rbclipper.vcxproj
- [ ] 配置 Ruby 2.7 和 3.2 属性表引用
- [ ] 设置 C++ 编译选项
- [ ] 添加到解决方案
- [ ] 测试编译 Debug (2.7)|x64
- [ ] 测试编译 Release (2.7)|x64
- [ ] 测试编译 Debug (3.2)|x64
- [ ] 测试编译 Release (3.2)|x64

## 参考文件
- 模板项目: `Hello World/Hello World.vcxproj`
- Ruby 属性: `Ruby 2.7 (x64).props`, `Ruby 3.2 (x64).props`
- 基础属性: `RubyExtension.props`

