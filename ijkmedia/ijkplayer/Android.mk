#
# Copyright (c) 2013 Bilibili
# Copyright (c) 2013 Zhang Rui <bbcallen@gmail.com>
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

# 这个文件是 ijkplayer 项目的核心播放器模块的 Android NDK Makefile，负责构建 ijkplayer 共享库，是整个多媒体播放器的核心实现部分。
# 这个 Android.mk 文件定义了 ijkplayer 核心播放器模块的完整构建配置：
# 1. 多媒体播放核心 : 实现了完整的媒体播放功能
# 2. 平台适配 : 专门针对 Android 平台的优化实现
# 3. 硬件加速 : 支持 MediaCodec 硬件解码
# 4. 格式支持 : 广泛的媒体格式和协议支持
# 5. 模块化设计 : 清晰的模块划分和依赖管理

# 设置当前模块路径
LOCAL_PATH := $(call my-dir)

# 清除之前的编译变量
include $(CLEAR_VARS)
# -mfloat-abi=soft is a workaround for FP register corruption on Exynos 4210
# http://www.spinics.net/lists/arm-kernel/msg368417.html

# 针对 armeabi-v7a 架构设置软浮点 ABI，解决 Exynos 4210 的 FP 寄存器损坏问题
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_CFLAGS += -mfloat-abi=soft
endif

# 使用 C99 标准进行编译
LOCAL_CFLAGS += -std=c99

# 链接 Android 的 log 和 android 库
LOCAL_LDLIBS += -llog -landroid

# 头文件包含路径配置
# - 当前目录 : 包含当前模块的头文件
# - 上级目录 : 包含 ijkmedia 目录的头文件
# - FFmpeg 路径 : 使用预定义的 FFmpeg 头文件路径
# - ijkj4a 路径 : 包含 Java 本地接口辅助库的头文件
LOCAL_C_INCLUDES += $(LOCAL_PATH)
LOCAL_C_INCLUDES += $(realpath $(LOCAL_PATH)/..)
LOCAL_C_INCLUDES += $(MY_APP_FFMPEG_INCLUDE_PATH)
LOCAL_C_INCLUDES += $(realpath $(LOCAL_PATH)/../ijkj4a)

# 核心源文件配置
LOCAL_SRC_FILES += ff_cmdutils.c														# 命令行工具辅助函数
LOCAL_SRC_FILES += ff_ffplay.c															# 基于 FFmpeg 的播放器主逻辑
LOCAL_SRC_FILES += ff_ffpipeline.c													# 媒体处理管道框架
LOCAL_SRC_FILES += ff_ffpipenode.c													# 管道节点实现
LOCAL_SRC_FILES += ijkmeta.c																# 媒体元数据处理
LOCAL_SRC_FILES += ijkplayer.c															# 播放器主接口

# 管道系统源文件
LOCAL_SRC_FILES += pipeline/ffpipeline_ffplay.c							# 标准 FFplay 播放管道实现
LOCAL_SRC_FILES += pipeline/ffpipenode_ffplay_vdec.c				# FFplay 视频解码节点

# Android 平台特定实现
LOCAL_SRC_FILES += android/ffmpeg_api_jni.c									# FFmpeg API 的 JNI 封装
LOCAL_SRC_FILES += android/ijkplayer_android.c							# Android 平台播放器适配
LOCAL_SRC_FILES += android/ijkplayer_jni.c									# Java 本地接口实现

LOCAL_SRC_FILES += android/pipeline/ffpipeline_android.c    # Android 平台媒体管道
LOCAL_SRC_FILES += android/pipeline/ffpipenode_android_mediacodec_vdec.c # 硬件加速视频解码节点

# 媒体格式处理模块
LOCAL_SRC_FILES += ijkavformat/allformats.c								  # 注册所有支持的媒体格式
LOCAL_SRC_FILES += ijkavformat/ijklivehook.c								# 直播流处理钩子
LOCAL_SRC_FILES += ijkavformat/ijkmediadatasource.c					# 媒体数据源实现
LOCAL_SRC_FILES += ijkavformat/ijkio.c											# 基础 IO 操作
LOCAL_SRC_FILES += ijkavformat/ijkiomanager.c								# IO 管理模块
LOCAL_SRC_FILES += ijkavformat/ijkiocache.c									# IO 缓存实现
LOCAL_SRC_FILES += ijkavformat/ijkioffio.c									# 文件系统 IO 封装
LOCAL_SRC_FILES += ijkavformat/ijkioandroidio.c							# Android 平台 IO 实现
LOCAL_SRC_FILES += ijkavformat/ijkioprotocol.c							# 协议处理模块
LOCAL_SRC_FILES += ijkavformat/ijkioapplication.c						# 应用层 IO 实现
LOCAL_SRC_FILES += ijkavformat/ijkiourlhook.c								# URL 钩子处理模块

# 工具库模块
LOCAL_SRC_FILES  += ijkavformat/ijkasync.c									# 异步操作模块
LOCAL_SRC_FILES  += ijkavformat/ijkurlhook.c								# URL 钩子处理模块
LOCAL_SRC_FILES  += ijkavformat/ijklongurl.c								# 长 URL 处理模块
LOCAL_SRC_FILES  += ijkavformat/ijksegment.c								# 媒体片段处理模块

LOCAL_SRC_FILES += ijkavutil/ijkdict.c											# 字典数据结构
LOCAL_SRC_FILES += ijkavutil/ijkutils.c											# 通用工具函数
LOCAL_SRC_FILES += ijkavutil/ijkthreadpool.c								# 线程池实现
LOCAL_SRC_FILES += ijkavutil/ijktree.c											# 树数据结构
LOCAL_SRC_FILES += ijkavutil/ijkfifo.c											# FIFO 队列实现
LOCAL_SRC_FILES += ijkavutil/ijkstl.cpp											# STL 容器封装

# 库依赖配置
# - 共享库依赖 :
# 	- ijkffmpeg : FFmpeg 多媒体处理库
# 	- ijksdl : 显示和音频输出库
# - 静态库依赖 :
# 	- android-ndk-profiler : Android NDK 性能分析器
# 	- ijksoundtouch : 音频处理库（音调、速度调整）
LOCAL_SHARED_LIBRARIES := ijkffmpeg ijksdl
LOCAL_STATIC_LIBRARIES := android-ndk-profiler ijksoundtouch

LOCAL_MODULE := ijkplayer

VERSION_SH  = $(LOCAL_PATH)/version.sh
VERSION_H   = ijkversion.h
$(info $(shell ($(VERSION_SH) $(LOCAL_PATH) $(VERSION_H))))
include $(BUILD_SHARED_LIBRARY)
