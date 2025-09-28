# Copyright (c) 2013 Bilibili
# copyright (c) 2013 Zhang Rui <bbcallen@gmail.com>
#
# This file is part of ijkPlayer.
#
# ijkPlayer is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# ijkPlayer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with ijkPlayer; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

# 这是 Android NDK 的应用级配置文件，负责定义整个 JNI 模块的编译环境和构建参数
# 文件整体功能
# 这个 Application.mk 文件的主要功能是：
# 1. 平台兼容性 : 确保生成的库与 Android 2.3+ 兼容
# 2. 性能优化 : 配置最高级别的编译优化
# 3. 架构特定 : 针对 ARMv7-A 架构进行优化
# 4. 工具链管理 : 指定稳定的 GCC 4.9 工具链
# 5. 标准库配置 : 使用静态链接的 STLport 库
# 设计特点
# 1. 性能优先 : 所有配置都面向发布版本优化
# 2. 兼容性考虑 : 选择较旧的平台版本确保广泛兼容
# 3. 架构优化 : 针对 ARMv7-A 架构的特定优化
# 4. 安全配置 : 包含必要的安全编译标志
# 构建流程 :
# 1. NDK 首先读取 Application.mk 设置全局环境
# 2. 然后读取 Android.mk 配置具体模块
# 3. 最后根据配置执行编译和链接


# 功能 : 设置编译优化级别
# - 值 : release (发布版本优化)
# - 作用 : 启用最高级别的优化，去除调试信息，提高性能
# - 可选值 : release (优化) / debug (调试)
APP_OPTIM := release
# 功能 : 指定目标 Android 平台版本
# - 值 : android-9 (对应 Android 2.3 Gingerbread)
# - 作用 : 确保生成的库与 Android 2.3 及以上版本兼容
# - API 级别 : 9
APP_PLATFORM := android-9
# 功能 : 指定目标 CPU 架构
# - 值 : armeabi-v7a (ARMv7-A 架构)
# - 作用 : 生成针对 ARMv7-A 架构的本地库
# - 特点 : 支持硬件浮点运算，性能优于 armeabi
APP_ABI := armeabi-v7a
# 功能 : 指定工具链版本
# - 值 : 4.9 (GCC 4.9 工具链)
# - 作用 : 使用 GCC 4.9 编译器进行编译
# - 特点 : 稳定性和兼容性较好
NDK_TOOLCHAIN_VERSION=4.9
# 功能 : 设置位置无关可执行文件选项
# - 值 : false (禁用 PIE)
# - 作用 : 生成非位置无关的可执行文件
# - 背景 : 在 Android 5.0 之前，PIE 不是强制要求
APP_PIE := false

# 功能 : 指定 C++ 标准库实现
# - 值 : stlport_static (静态链接的 STLport 库)
# - 作用 : 使用 STLport 标准库的静态链接版本
# - 优点 : 减少依赖，库文件自包含
# - 替代方案 : gnustl_static , c++_static 等
APP_STL := stlport_static

# 编译器优化标志配置 :
# -O3 : 最高级别的优化，包括向量化等高级优化
# -ffast-math : 快速数学运算，牺牲精度换取速度
# -fstrict-aliasing : 启用严格别名优化
# 警告和错误处理 :
# -Wall : 启用所有常见警告
# -Werror=strict-aliasing : 将严格别名警告视为错误
# -Wno-psabi : 禁用 ABI 相关警告
# 安全标志 :
# -Wa,--noexecstack : 确保生成的代码不可执行栈
# 预定义宏 :
# -DANDROID : 定义 Android 平台宏
# -DNDEBUG : 定义非调试模式宏，禁用断言
APP_CFLAGS := -O3 -Wall -pipe \
    -ffast-math \
    -fstrict-aliasing -Werror=strict-aliasing \
    -Wno-psabi -Wa,--noexecstack \
    -DANDROID -DNDEBUG
