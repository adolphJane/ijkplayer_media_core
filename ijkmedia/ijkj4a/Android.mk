# copyright (c) 2016 Zhang Rui <bbcallen@gmail.com>
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

# 这个 ijkj4a 模块是 ijkplayer 项目 Java 和 C/C++ 层之间的关键桥梁，它封装了复杂的 JNI 调用，提供了简洁高效的接口，使得 Java 层能够方便地调用底层的多媒体处理功能。

# 模块功能总结
# 1. JNI 桥梁功能
# ijkj4a 模块的主要作用是提供 Java 和 C/C++ 之间的桥梁：
# - 封装 Java 类的 JNI 调用
# - 提供类型转换和内存管理
# - 简化 JNI 开发复杂度
# 2. 媒体功能支持
# - 音频处理 : AudioTrack 的封装和控制
# - 硬件加速 : MediaCodec 的硬件编解码接口
# - 格式处理 : MediaFormat 的格式信息管理
# - 参数控制 : PlaybackParams 的播放参数调整
# 3. 系统集成
# - 设备信息 : 获取设备构建信息和特性
# - 数据传递 : Bundle 的数据包传递机制
# - 内存管理 : NIO 缓冲区的直接内存操作
# 4. 自定义接口
# - 数据源扩展 : 支持自定义媒体数据源
# - 平台适配 : Android 特有的 I/O 操作
# - 播放器控制 : 主播放器类的完整 JNI 接口

# 设计特点
# 1. 模块化设计
# - 每个 Java 类都有独立的封装文件
# - 清晰的目录结构组织
# - 便于维护和扩展
# 2. 静态库构建
# - 构建为静态库，减少运行时依赖
# - 与其他模块链接形成完整的播放器
# - 优化最终二进制大小
# 3. 标准化接口
# - 统一的 JNI 调用规范
# - 一致的错误处理机制
# - 标准化的类型转换
# 4. 性能优化
# - 直接内存操作减少拷贝
# - 硬件加速接口支持
# - CPU 特性检测优化

# 在项目中的作用
# 构建依赖关系
# ```
# ijkplayer (共享库)
#     ├── 依赖 ijkj4a (静态库)
#     ├── 依赖 ijkffmpeg (共享库)
#     └── 依赖 ijksdl (共享库)
# ```
# 功能流程
# 1. Java 层调用 → ijkj4a JNI 接口 → C/C++ 核心逻辑
# 2. 媒体数据处理 → 通过 JNI 返回 Java 层
# 3. 硬件加速 → 通过 MediaCodec 接口实现
# 4. 音频输出 → 通过 AudioTrack 控制

# 实际应用场景
# - 播放器初始化 : 通过 IjkMediaPlayer JNI 接口初始化
# - 硬件解码 : 通过 MediaCodec 接口实现硬件加速
# - 音频输出 : 通过 AudioTrack 控制音频播放
# - 数据传递 : 通过 Bundle 和 ByteBuffer 传递数据


# 设置当前模块路径
LOCAL_PATH := $(call my-dir)
# 清除之前的编译变量
include $(CLEAR_VARS)
# 使用 C99 标准进行编译
LOCAL_CFLAGS += -std=c99

# 头文件包含路径配置
# 包含当前模块的头文件
LOCAL_C_INCLUDES += $(LOCAL_PATH)
# 使用绝对路径确保路径正确性
LOCAL_C_INCLUDES += $(realpath $(LOCAL_PATH))

# J4A 核心源文件配置
LOCAL_SRC_FILES += j4a/j4a_allclasses.c																							# 所有 Java 类的注册和管理
LOCAL_SRC_FILES += j4a/j4a_base.c																										# JNI 基础功能和工具函数

# Android 媒体类封装
LOCAL_SRC_FILES += j4a/class/android/media/AudioTrack.c															# 音频轨道控制
LOCAL_SRC_FILES += j4a/class/android/media/MediaCodec.c															# 硬件编解码器接口
LOCAL_SRC_FILES += j4a/class/android/media/MediaFormat.c														# 媒体格式信息
LOCAL_SRC_FILES += j4a/class/android/media/PlaybackParams.c													# 播放参数控制

# 系统类封装
LOCAL_SRC_FILES += j4a/class/android/os/Build.c																			# 设备构建信息
LOCAL_SRC_FILES += j4a/class/android/os/Bundle.c																		# 数据包传递
LOCAL_SRC_FILES += j4a/class/java/nio/Buffer.c																		  # NIO 缓冲区操作
LOCAL_SRC_FILES += j4a/class/java/nio/ByteBuffer.c

# 集合类封装
LOCAL_SRC_FILES += j4a/class/java/util/ArrayList.c																	# Java 集合类的封装

# ijkplayer 自定义类封装
LOCAL_SRC_FILES += j4a/class/tv/danmaku/ijk/media/player/misc/IMediaDataSource.c		# 自定义媒体数据源接口
LOCAL_SRC_FILES += j4a/class/tv/danmaku/ijk/media/player/misc/IAndroidIO.c					# Android 平台 I/O 操作接口
LOCAL_SRC_FILES += j4a/class/tv/danmaku/ijk/media/player/IjkMediaPlayer.c						# 主播放器类的 JNI 接口

# J4AU 工具类源文件
LOCAL_SRC_FILES += j4au/class/android/media/AudioTrack.util.c												# AudioTrack 的工具函数
LOCAL_SRC_FILES += j4au/class/java/nio/ByteBuffer.util.c														# ByteBuffer 的工具函数

# 模块构建配置
# 定义模块名为 ijkj4a
LOCAL_MODULE := ijkj4a
# 构建为 静态库 （.a 文件），与其他模块链接
include $(BUILD_STATIC_LIBRARY)

# 外部模块导入
# - CPU 特性检测 : 导入 Android NDK 的 CPU 特性检测模块
# - 用于检测设备的 CPU 特性，优化性能
$(call import-module,android/cpufeatures)
