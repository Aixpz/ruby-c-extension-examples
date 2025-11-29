# SketchUp Ruby C/C++ Extension Examples 项目概览

## 项目用途
该仓库提供一套可直接编译的 C/C++ 示例，用于演示如何为 SketchUp 创建 Ruby 扩展（C Extension）。内容涵盖：
- 不同 Ruby 版本与平台所需的头文件、库和工程模板（Visual Studio、Xcode）。
- 一个最小可行的 “Hello World” 扩展，展示如何向 Ruby 暴露模块、常量与方法。
- 使用 SWIG 在 Ruby 与 C++ 间双向通信的示例，包括必要的接口类与 `.i` 配置。
- 若干辅助 Ruby 脚本，帮助在 SketchUp 中加载调试扩展或检查编译产物。

## 目录要点
- `Hello World/`：VS 与 Xcode 工程，源文件位于 `src/`，其中 `SUEX_HelloWorld.cpp` 定义 `Init_SUEX_HelloWorld()`，示范如何 register Ruby 方法，`RubyUtils/` 提供 `VALUEFUNC`、`GetRubyInterface` 等跨类型转换工具。
- `SUEX_UsingSWIG/`：包含 `MyNativeClass`、`INativeToRuby` 等 C++ 代码与 `Swig_input.i`，展示 SWIG directors 让 Ruby 类实现 C++ 接口，再在本地代码中回调 Ruby。
- `Ruby/`：`launch_sketchup.rb` 用于在 SketchUp 内载入编译生成的 `.so/.bundle`，`SwigExample.rb` 展示如何继承 SWIG 生成的接口，`inspect_strings.rb` 可检查二进制中记录的架构/路径字串。
- `ThirdParty/`：打包 Ruby 1.8–3.2 的头文件与 macOS/Windows 对应库，以及 Windows 版 SWIG，可直接用于本仓库工程。
- 顶层 `*.props`、`.sln`、`.xcworkspace` 等文件帮助快速在 VS/Xcode 中切换不同 Ruby 版本、平台与配置。

## 构建与调试
### Visual Studio 2022（Hello World）
1. 使用 `SketchUp Ruby C Extension Examples.sln` 打开解决方案。
2. `SUEX_HelloWorld` 项目名需与 `Init_<ProjectName>` 一致，`.def` 文件也需导出同名符号。
3. 在 `项目 > 属性 > 调试` 中配置 SketchUp 可执行路径，工程默认按不同配置启动对应版本，以便按 F5 进入 SketchUp 并自动加载扩展调试。
4. 若需同时兼容 SU2014–SU2017，注意 `/MD` vs `/MT` CRT 选择，必要时参考 `RubyUtils/RubyLib.h` 中的宏并确保目标机器具备对应 VC++ Runtime。

### Xcode 14（Hello World）
1. 打开 `SUEX_HelloWorld.xcodeproj` 或顶层 `.xcworkspace`。
2. 工程预先配置了从 Ruby 2.0 起的多个 macOS 目标，可在 Scheme 中切换。
3. 生成的 `.bundle` 位于 `Debug (版本)/` 目录，可配合 `Ruby/launch_sketchup.rb` 自动 `require` 并载入。
4. `macOS.md` 列出常用命令：使用 `file` 查看二进制架构，`otool -l` 检查 deployment target（x86_64 使用 `LC_VERSION_MIN_MACOSX`，arm64 使用 `LC_BUILD_VERSION`）。

### SWIG 示例
1. 运行 `swig.exe`（`ThirdParty/bin/win32/swig`）或本地 SWIG，基于 `Swig_input.i` 生成绑定代码，开启 `directors` 以允许 Ruby 实现 C++ 接口。
2. 使用 `SUEX_UsingSWIG.vcxproj` 编译，生成的 `.so`/`.bundle` 在 `Debug (版本)` 或 `Debug (版本)/x64`。
3. `Ruby/SwigExample.rb` 中：
   ```ruby
   class FromNative < SUEX_UsingSWIG::INativeToRuby
     def CallFromNative(message)
       UI.messagebox(message)
     end
   end
   native_obj = SUEX_UsingSWIG::MyNativeClass.new(FromNative.new)
   native_obj.CallBackToRuby('This came from Ruby')
   ```
   该示例展示 Ruby 将对象传入 C++，再由 C++ 回调 Ruby 方法。

## 推荐使用流程
1. **准备依赖**：安装与目标 SketchUp 版本匹配的 Ruby 头文件/库（仓库已内置），以及 VS/Xcode、SWIG 等工具链。
2. **选择示例**：从 `Hello World` 入手理解基础导出流程，再切换到 `SUEX_UsingSWIG` 练习复杂交互。
3. **编译目标**：根据所需 Ruby 版本切换对应 `Debug (2.0)`、`Debug (2.7)` 等配置，Windows 平台还需区分 `x64`。
4. **加载测试**：在 SketchUp Ruby 控制台运行 `ruby/launch_sketchup.rb`（提前设置 `RELEASE` 或在命令行传入 `Configuration:Platform`），自动 `require` 所有 `.so/.bundle` 并输出加载日志。
5. **验证二进制**：macOS 可用 `file`/`otool` 检查架构与最低系统版本，`Ruby/inspect_strings.rb <版本>` 可解析 `.bundle` 内嵌字符串确认路径。

## 备注
- 所有源码均与 SketchUp Ruby API 的发布许可证兼容；详细版权信息可见 `LICENSE`。
- Windows 用户若选择 `/MD`，需确保终端用户已安装对应 VC++ Runtime；若使用 `/MT`，需参考 `TestUp` 项目中对 Ruby 配置的额外宏处理。
- 若追求跨平台通用性，可借助 `ThirdParty/include` 与 `ThirdParty/lib` 中的多版本文件快速切换编译目标。

通过上述资源，开发者可以在 macOS 与 Windows 上迅速搭建 SketchUp Ruby C 扩展的开发、调试与分发流水线，并在需要时扩展到更复杂的跨语言调用场景。


