# rbclipper macOS 编译指南

## 方案 2：使用 extconf.rb 编译

### 前置条件

1. **macOS 系统**（10.14 或更高）
2. **Xcode Command Line Tools**
   ```bash
   xcode-select --install
   ```
3. **Ruby**（用于运行 extconf.rb）

### 步骤 1：准备源文件

确保源文件在正确位置：
```
rbclipper/
├── extconf_sketchup.rb  # 配置文件
└── src/
    ├── rbclipper.cpp
    ├── clipper.cpp
    └── clipper.hpp
```

### 步骤 2：运行 extconf.rb

**基本用法：**
```bash
cd rbclipper
ruby extconf_sketchup.rb
```

**指定 Ruby 版本：**
```bash
# Ruby 2.7
ruby extconf_sketchup.rb --ruby-version=2.7

# Ruby 3.2
ruby extconf_sketchup.rb --ruby-version=3.2
```

**指定架构：**
```bash
# Intel Mac (x86_64)
ruby extconf_sketchup.rb --ruby-version=2.7 --arch=x86_64

# Apple Silicon Mac (arm64)
ruby extconf_sketchup.rb --ruby-version=2.7 --arch=arm64

# Universal Binary (推荐，兼容两种架构)
ruby extconf_sketchup.rb --ruby-version=2.7 --arch=universal
```

### 步骤 3：编译

```bash
make
```

### 步骤 4：验证输出

```bash
# 检查生成的文件
ls -la clipper.bundle

# 检查架构
file clipper.bundle

# 检查依赖
otool -L clipper.bundle
```

### 完整示例

```bash
# 1. 进入项目目录
cd /path/to/ruby-c-extension-examples/rbclipper

# 2. 配置（Ruby 2.7, Universal）
ruby extconf_sketchup.rb --ruby-version=2.7 --arch=universal

# 3. 编译
make

# 4. 清理（可选）
# make clean
```

## 需要指定的配置

### 必须指定：

1. **Ruby 版本** (`--ruby-version=2.7` 或 `3.2`)
   - 对应 SketchUp 使用的 Ruby 版本
   - 需要匹配 `ThirdParty/include/ruby/` 中的版本

2. **架构** (`--arch=x86_64|arm64|universal`)
   - `x86_64`: Intel Mac
   - `arm64`: Apple Silicon Mac
   - `universal`: 通用二进制（推荐）

### 自动检测的配置：

- Ruby 头文件路径：`ThirdParty/include/ruby/{版本}/mac/`
- Ruby 框架路径：`ThirdParty/lib/mac/{版本}/Ruby.framework`
- 源文件路径：`src/` 目录
- 输出文件名：`clipper.bundle`

## 注意事项

1. **Ruby 版本匹配**
   - 确保指定的 Ruby 版本与 SketchUp 版本匹配
   - SU2021-2022 使用 Ruby 2.7
   - SU2023+ 使用 Ruby 3.2

2. **架构兼容性**
   - Universal binary 可以在两种架构上运行
   - 但文件会更大

3. **部署目标**
   - 默认设置为 macOS 10.14+
   - 可根据需要调整 `-mmacosx-version-min`

4. **依赖检查**
   - 编译前确保 `ThirdParty` 目录中有对应的 Ruby 头文件和框架

## 故障排除

### 错误：找不到 Ruby 头文件

```
Error: Ruby 2.7 headers not found at ...
```

**解决**：检查 `ThirdParty/include/ruby/2.7/mac/` 是否存在

### 错误：找不到 Ruby 框架

```
Error: Ruby 2.7 framework not found at ...
```

**解决**：检查 `ThirdParty/lib/mac/2.7/Ruby.framework` 是否存在

### 错误：架构不匹配

**解决**：确保指定了正确的架构，或使用 `universal`

### 错误：无法链接

**解决**：确保 Xcode Command Line Tools 已安装

