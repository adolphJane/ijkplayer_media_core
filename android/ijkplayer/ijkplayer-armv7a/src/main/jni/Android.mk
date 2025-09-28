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

# 主文件：环境配置 + 子模块包含
# 主 Android.mk 文件，负责整个 JNI 模块的构建配置
# 一. 文件整体功能
# 这个主 Android.mk 文件的主要功能是：
# 1. 环境配置 : 设置项目各级目录的路径变量
# 2. 架构适配 : 根据目标架构配置相应的 FFmpeg 路径
# 3. 模块集成 : 通过递归包含实现子模块的自动集成
# 4. 构建协调 : 作为整个 JNI 模块的构建入口点
# 二. 工作流程
# 1. NDK 构建启动 : 当执行 ndk-build 时，NDK 首先读取这个主 Makefile
# 2. 路径变量设置 : 计算并设置项目各级目录的绝对路径
# 3. 架构检测 : 根据 TARGET_ARCH_ABI 设置对应的 FFmpeg 路径
# 4. 子模块加载 : 递归包含所有子目录的 Android.mk 文件
# 5. 构建执行 : NDK 根据所有配置执行实际的编译和链接过程


# 功能 : 定义关键路径变量
# 当前 Makefile 所在目录
LOCAL_PATH := $(call my-dir)
# JNI 根目录的绝对路径
MY_APP_JNI_ROOT := $(realpath $(LOCAL_PATH))
# 项目根目录（JNI 的父目录）
MY_APP_PRJ_ROOT := $(realpath $(MY_APP_JNI_ROOT)/..)
# Android 项目根目录（向上4级目录）
MY_APP_ANDROID_ROOT := $(realpath $(MY_APP_PRJ_ROOT)/../../../..)

# 功能 : 根据目标架构设置 FFmpeg 相关路径
# - TARGET_ARCH_ABI : NDK 内置变量，表示当前编译的目标架构
# - MY_APP_FFMPEG_OUTPUT_PATH : FFmpeg 预编译库的输出路径
# - MY_APP_FFMPEG_INCLUDE_PATH : FFmpeg 头文件路径
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
MY_APP_FFMPEG_OUTPUT_PATH := $(realpath $(MY_APP_ANDROID_ROOT)/contrib/build/ffmpeg-armv7a/output)
MY_APP_FFMPEG_INCLUDE_PATH := $(realpath $(MY_APP_FFMPEG_OUTPUT_PATH)/include)
endif
ifeq ($(TARGET_ARCH_ABI),armeabi)
MY_APP_FFMPEG_OUTPUT_PATH := $(realpath $(MY_APP_ANDROID_ROOT)/contrib/build/ffmpeg-armv5/output)
MY_APP_FFMPEG_INCLUDE_PATH := $(realpath $(MY_APP_FFMPEG_OUTPUT_PATH)/include)
endif
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
MY_APP_FFMPEG_OUTPUT_PATH := $(realpath $(MY_APP_ANDROID_ROOT)/contrib/build/ffmpeg-arm64/output)
MY_APP_FFMPEG_INCLUDE_PATH := $(realpath $(MY_APP_FFMPEG_OUTPUT_PATH)/include)
endif
ifeq ($(TARGET_ARCH_ABI),x86)
MY_APP_FFMPEG_OUTPUT_PATH := $(realpath $(MY_APP_ANDROID_ROOT)/contrib/build/ffmpeg-x86/output)
MY_APP_FFMPEG_INCLUDE_PATH := $(realpath $(MY_APP_FFMPEG_OUTPUT_PATH)/include)
endif
ifeq ($(TARGET_ARCH_ABI),x86_64)
MY_APP_FFMPEG_OUTPUT_PATH := $(realpath $(MY_APP_ANDROID_ROOT)/contrib/build/ffmpeg-x86_64/output)
MY_APP_FFMPEG_INCLUDE_PATH := $(realpath $(MY_APP_FFMPEG_OUTPUT_PATH)/include)
endif

# 功能 : 包含所有子目录中的 Makefile 文件
# - $(call all-subdir-makefiles) : NDK 内置函数，递归查找并包含所有子目录的 Android.mk 文件
# - 作用 : 自动加载 ffmpeg/Android.mk 等子模块的构建配置
include $(call all-subdir-makefiles)
