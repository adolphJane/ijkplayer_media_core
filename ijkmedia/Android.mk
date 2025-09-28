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

# 根据目录结构，这个文件管理以下三个核心子模块：
# 1. ijkj4a/ - Java 本地接口模块
# - 负责 Java 和 C/C++ 之间的接口桥接
# - 提供 JNI 封装和类型转换功能
# 2. ijkplayer/ - 核心播放器模块
# - 包含播放器的主要逻辑和状态管理
# - 集成 FFmpeg 进行音视频解码
# - 处理媒体流控制和同步
# 3. ijksdl/ - 简单显示层模块
# - 负责音视频渲染和显示
# - 提供音频输出、视频渲染功能
# - 处理窗口管理和用户交互

# 文件整体功能
# 这个 Android.mk 文件的主要功能是：
# 1. 模块协调 : 作为 ijkmedia 模块的构建入口点
# 2. 递归构建 : 自动发现和构建所有子模块
# 3. 路径管理 : 设置正确的构建环境路径
# 4. 依赖管理 : 确保子模块按照正确顺序构建

# 构建流程
# 当 NDK 构建系统处理这个文件时：
# 1. 路径设置 : 设置 LOCAL_PATH 为 ijkmedia 目录
# 2. 递归搜索 : 调用 all-subdir-makefiles 函数搜索子目录
# 3. 子模块构建 : 按顺序包含以下子模块的 Android.mk：
#    - ijkj4a/Android.mk
#    - ijkplayer/Android.mk
#    - ijksdl/Android.mk
# 4. 依赖解析 : NDK 自动解析模块间的依赖关系
# 5. 最终链接 : 将所有子模块链接成最终的共享库

# 设计特点
# 1. 模块化设计 : 将复杂功能分解为独立的子模块
# 2. 自动化构建 : 使用递归包含简化构建配置
# 3. 职责分离 : 每个子模块专注于特定功能领域
# 4. 可扩展性 : 易于添加新的功能模块

# 在项目中的位置和作用
# 文件层级关系 :

# ```
# jni/
# ├── Android.mk              # 主构建文件
# ├── Application.mk          # 应用配置
# ├── ffmpeg/Android.mk       # FFmpeg 预编译库
# └── ijkmedia/               # 核心媒体模块
#     ├── Android.mk          # ← 当前分析的文件
#     ├── ijkj4a/Android.mk   # JNI 接口模块
#     ├── ijkplayer/Android.mk # 播放器核心模块
#     └── ijksdl/Android.mk   # 显示层模块
# ```
# 构建顺序 :

# 1. 预编译 FFmpeg 库 ( ffmpeg/Android.mk )
# 2. ijkmedia 模块及其子模块
# 3. 最终链接生成 libijkplayer.so



# 功能 : 设置当前模块的路径
# - $(call my-dir) : NDK 内置函数，返回当前 Makefile 所在的目录路径
# - LOCAL_PATH : 标准变量，用于存储当前模块的路径
# - 作用 : 确保后续的文件引用基于正确的相对路径
LOCAL_PATH := $(call my-dir)

# 功能 : 递归包含所有子目录中的 Makefile 文件
# - $(call all-subdir-makefiles) : NDK 内置函数，自动查找并包含所有子目录的 Android.mk 文件
# - 作用 : 实现模块化的构建配置管理
include $(call all-subdir-makefiles)
