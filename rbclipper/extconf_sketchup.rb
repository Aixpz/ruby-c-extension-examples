#!/usr/bin/env ruby
# extconf.rb for SketchUp Ruby Extension
# Usage: ruby extconf_sketchup.rb [--ruby-version=2.7|3.2] [--arch=x86_64|arm64|universal]

require 'mkmf'

# 获取项目根目录（假设此文件在 rbclipper/ 目录下）
PROJECT_ROOT = File.expand_path('..', __dir__)
THIRDPARTY_DIR = File.join(PROJECT_ROOT, 'ThirdParty')

# 解析命令行参数
ruby_version = '2.7'
arch = 'universal'  # universal, x86_64, 或 arm64

ARGV.each do |arg|
  case arg
  when /--ruby-version=(.+)/
    ruby_version = $1
  when /--arch=(.+)/
    arch = $1
  end
end

puts "Configuring for SketchUp Ruby #{ruby_version} (#{arch})"

# 设置 Ruby 头文件路径
ruby_include_dir = File.join(THIRDPARTY_DIR, 'include', 'ruby', ruby_version, 'mac')
if !Dir.exist?(ruby_include_dir)
  abort "Error: Ruby #{ruby_version} headers not found at #{ruby_include_dir}"
end

# 设置 Ruby 库文件路径
ruby_lib_dir = File.join(THIRDPARTY_DIR, 'lib', 'mac')
ruby_framework = File.join(ruby_lib_dir, ruby_version, 'Ruby.framework')

if !Dir.exist?(ruby_framework)
  abort "Error: Ruby #{ruby_version} framework not found at #{ruby_framework}"
end

# 配置包含目录
dir_config('clipper', ruby_include_dir)

# 添加 Ruby 头文件目录到包含路径
$INCFLAGS << " -I#{ruby_include_dir}"
$INCFLAGS << " -I#{File.join(ruby_include_dir, 'ruby')}"

# 配置库文件和链接选项
# macOS 使用 Framework 而不是静态库
$LDFLAGS << " -F#{ruby_lib_dir}/#{ruby_version}"
$LDFLAGS << " -framework Ruby"

# 设置源文件目录（如果需要）
$VPATH << File.join(__dir__, 'src')

# 设置编译器选项
CONFIG['CC'] = 'clang++'  # 使用 C++ 编译器
CONFIG['LDSHARED'] = "$(CXX) -shared"  # 确保使用 C++ 链接器

# 设置架构选项
if arch == 'universal'
  # Universal binary (支持 x86_64 和 arm64)
  $CFLAGS << " -arch x86_64 -arch arm64"
  $LDFLAGS << " -arch x86_64 -arch arm64"
elsif arch == 'x86_64'
  $CFLAGS << " -arch x86_64"
  $LDFLAGS << " -arch x86_64"
elsif arch == 'arm64'
  $CFLAGS << " -arch arm64"
  $LDFLAGS << " -arch arm64"
end

# 设置部署目标（根据 SketchUp 版本调整）
# SU2021+ 需要 macOS 10.14+
$CFLAGS << " -mmacosx-version-min=10.14"
$LDFLAGS << " -mmacosx-version-min=10.14"

# 设置输出文件名
CONFIG['TARGET_SO'] = 'clipper.bundle'

puts "Ruby include directory: #{ruby_include_dir}"
puts "Ruby framework: #{ruby_framework}"
puts "Architecture: #{arch}"
puts "Output: #{CONFIG['TARGET_SO']}"

# 创建 Makefile
create_makefile('clipper')

puts "\nConfiguration complete!"
puts "To build, run: make"
puts "Output will be: #{CONFIG['TARGET_SO']}"

