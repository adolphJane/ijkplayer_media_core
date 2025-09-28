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

# 这是 ijksdl (Simple DirectMedia Layer) 模块的 Android.mk 文件，负责构建 ijkplayer 的显示和音频输出层。这是 ijkplayer 项目中功能最丰富的模块之一

# 模块功能总结
# ijksdl 模块提供以下核心功能：
#  6.1 音频输出系统
# - AudioTrack : Android 标准音频输出
# - OpenSL ES : 低延迟音频输出
# - 音频同步 : 音视频同步处理 6.2 视频渲染系统
# - OpenGL ES 2.0 : 硬件加速渲染
# - 多格式支持 : RGB、YUV420P、YUV444 等
# - 着色器渲染 : 可编程渲染管线 6.3 Android 平台集成
# - NativeWindow : 原生窗口管理
# - Surface : Android Surface 渲染
# - MediaCodec : 硬件解码器集成 6.4 媒体处理
# - 图像格式转换 : YUV/RGB 转换
# - 覆盖层渲染 : 字幕、水印等叠加
# - 硬件加速 : 利用 GPU 进行图像处理

# 设计特点
# 1. 跨平台抽象 : 通过抽象层支持不同平台实现
# 2. 硬件加速 : 充分利用 Android 硬件能力
# 3. 模块化设计 : 音频、视频、渲染分离
# 4. 性能优化 : 针对移动设备优化渲染性能
# 5. 格式兼容 : 支持多种音视频格式

# 在项目中的作用
# ijksdl 是 ijkplayer 的显示和音频核心，负责：
# - 将解码后的音视频数据呈现给用户
# - 处理音视频同步
# - 提供硬件加速渲染
# - 集成 Android 平台特性
# 这个模块的设计体现了现代移动媒体播放器的核心要求：高性能、低功耗、良好的用户体验。


LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# 功能 : 设置 C 语言标准为 C99
# 作用 : 启用 C99 标准特性，如内联函数、变长数组等
LOCAL_CFLAGS += -std=c99

# 功能 : 链接 Android 系统库
# 库说明 :
# -llog : Android 日志库
# -landroid : Android NDK 基础库
# -lOpenSLES : OpenSL ES 音频库
# -lEGL : EGL 图形库
# -lGLESv2 : OpenGL ES 2.0 图形库
LOCAL_LDLIBS += -llog -landroid -lOpenSLES -lEGL -lGLESv2

# LOCAL_C_INCLUDES : 头文件包含路径
# - 当前目录和父目录
# - FFmpeg 头文件路径
# - libyuv 头文件路径（用于 YUV 格式转换）
# - ijkj4a 头文件路径（JNI 接口）
LOCAL_C_INCLUDES += $(LOCAL_PATH)
LOCAL_C_INCLUDES += $(realpath $(LOCAL_PATH)/..)
LOCAL_C_INCLUDES += $(MY_APP_FFMPEG_INCLUDE_PATH)
LOCAL_C_INCLUDES += $(realpath $(LOCAL_PATH)/../ijkyuv/include)
LOCAL_C_INCLUDES += $(realpath $(LOCAL_PATH)/../ijkj4a)

# 核心功能源文件
LOCAL_SRC_FILES += ijksdl_aout.c												# 音频输出抽象层
LOCAL_SRC_FILES += ijksdl_audio.c												# 音频处理核心
LOCAL_SRC_FILES += ijksdl_egl.c													# EGL 图形上下文管理
LOCAL_SRC_FILES += ijksdl_error.c												# 错误处理
LOCAL_SRC_FILES += ijksdl_mutex.c												# 互斥锁
LOCAL_SRC_FILES += ijksdl_stdinc.c											# 标准头文件
LOCAL_SRC_FILES += ijksdl_thread.c											# 线程处理
LOCAL_SRC_FILES += ijksdl_timer.c												# 定时器
LOCAL_SRC_FILES += ijksdl_vout.c												# 视频输出抽象层
LOCAL_SRC_FILES += ijksdl_extra_log.c										# 扩展日志记录

# OpenGL ES 2.0 渲染器
LOCAL_SRC_FILES += gles2/color.c												# 颜色处理
LOCAL_SRC_FILES += gles2/common.c												# 通用函数
LOCAL_SRC_FILES += gles2/renderer.c											# 渲染器
LOCAL_SRC_FILES += gles2/renderer_rgb.c									# RGB 格式渲染器
LOCAL_SRC_FILES += gles2/renderer_yuv420p.c							# YUV420P 格式渲染器
LOCAL_SRC_FILES += gles2/renderer_yuv444p10le.c					# YUV444 10位格式渲染器
LOCAL_SRC_FILES += gles2/shader.c												# 着色器管理
LOCAL_SRC_FILES += gles2/fsh/rgb.fsh.c									# RGB 格式片段着色器
LOCAL_SRC_FILES += gles2/fsh/yuv420p.fsh.c							# YUV420P 格式片段着色器
LOCAL_SRC_FILES += gles2/fsh/yuv444p10le.fsh.c					# YUV444 10位格式片段着色器
LOCAL_SRC_FILES += gles2/vsh/mvp.vsh.c									# 模型视图投影顶点着色器

# 虚拟输出实现
LOCAL_SRC_FILES += dummy/ijksdl_vout_dummy.c						# 虚拟视频输出（用于测试）

# FFmpeg 相关
LOCAL_SRC_FILES += ffmpeg/ijksdl_vout_overlay_ffmpeg.c	# FFmpeg 覆盖层输出
LOCAL_SRC_FILES += ffmpeg/abi_all/image_convert.c				# 图像格式转换

# Android 平台实现
LOCAL_SRC_FILES += android/android_audiotrack.c														# AudioTrack 音频输出
LOCAL_SRC_FILES += android/android_nativewindow.c													# NativeWindow 管理
LOCAL_SRC_FILES += android/ijksdl_android_jni.c														# Android JNI 接口
LOCAL_SRC_FILES += android/ijksdl_aout_android_audiotrack.c								# AudioTrack 音频输出实现
LOCAL_SRC_FILES += android/ijksdl_aout_android_opensles.c									# OpenSL ES 音频输出实现
LOCAL_SRC_FILES += android/ijksdl_codec_android_mediacodec_dummy.c				# MediaCodec 虚拟实现
LOCAL_SRC_FILES += android/ijksdl_codec_android_mediacodec_internal.c			# MediaCodec 内部实现
LOCAL_SRC_FILES += android/ijksdl_codec_android_mediacodec_java.c					# MediaCodec Java 接口
LOCAL_SRC_FILES += android/ijksdl_codec_android_mediacodec.c							# MediaCodec 核心实现
LOCAL_SRC_FILES += android/ijksdl_codec_android_mediadef.c								# MediaCodec 定义
LOCAL_SRC_FILES += android/ijksdl_codec_android_mediaformat_java.c				# MediaFormat Java 接口
LOCAL_SRC_FILES += android/ijksdl_codec_android_mediaformat.c							# MediaFormat 核心实现
LOCAL_SRC_FILES += android/ijksdl_vout_android_nativewindow.c							# NativeWindow 视频输出
LOCAL_SRC_FILES += android/ijksdl_vout_android_surface.c									# Surface 视频输出
LOCAL_SRC_FILES += android/ijksdl_vout_overlay_android_mediacodec.c				# MediaCodec 覆盖层输出

# 库依赖配置
# - 共享库 : ijkffmpeg (FFmpeg 功能库)
# - 静态库 :
# 	- cpufeatures (CPU 特性检测)
# 	- yuv_static (libyuv 图像处理库)
# 	- ijkj4a (JNI 接口库)
LOCAL_SHARED_LIBRARIES := ijkffmpeg
LOCAL_STATIC_LIBRARIES := cpufeatures yuv_static ijkj4a

# 模块构建配置
# 功能 :
# - LOCAL_MODULE := ijksdl : 定义模块名称为 ijksdl
# - include $(BUILD_SHARED_LIBRARY) : 构建共享库
# - $(call import-module,android/cpufeatures) : 导入 CPU 特性检测模块
LOCAL_MODULE := ijksdl
include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/cpufeatures)
