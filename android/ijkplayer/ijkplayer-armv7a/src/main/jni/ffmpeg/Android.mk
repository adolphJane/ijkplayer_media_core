# 设置当前模块的路径
# - $(call my-dir) : 调用 NDK 内置函数，返回当前 Makefile 所在的目录路径
# - LOCAL_PATH : 标准变量，用于存储当前模块的路径
# - 作用 : 确保后续的文件引用基于正确的相对路径
LOCAL_PATH := $(call my-dir)

# 引入第三方预编译的动态库（如这里的 ijkffmpeg，一个基于 FFmpeg 的 Android 音视频库），而无需重新编译该库的源码。

# 功能 : 清除所有局部变量
# - $(CLEAR_VARS) : NDK 内置变量，指向清除变量的脚本文件
# - 作用 : 确保每个模块的变量定义是独立的，避免模块间的变量污染
include $(CLEAR_VARS)
# 功能 : 定义模块名称
# - LOCAL_MODULE : 标准变量，用于指定生成的库文件名
# - ijkffmpeg : 模块名称，最终生成的库文件为 libijkffmpeg.so
# - 命名规则 : Android 会自动添加 lib 前缀和 .so 后缀
LOCAL_MODULE := ijkffmpeg
# 功能 : 指定预编译库的源文件路径
# - LOCAL_SRC_FILES : 标准变量，用于指定源文件
# - $(MY_APP_FFMPEG_OUTPUT_PATH) : 自定义变量，指向 FFmpeg 预编译库的输出路径
# - libijkffmpeg.so : 预编译的 FFmpeg 共享库文件名
# - 作用 : 告诉 NDK 使用已经编译好的 FFmpeg 库，而不是重新编译
LOCAL_SRC_FILES := $(MY_APP_FFMPEG_OUTPUT_PATH)/libijkffmpeg.so
# 功能 : 包含预编译共享库的构建规则
# - $(PREBUILT_SHARED_LIBRARY) : NDK 内置变量，指向预编译共享库的构建脚本
# - 作用 : 指示 NDK 这是一个预编译的共享库，不需要重新编译源代码
include $(PREBUILT_SHARED_LIBRARY)
