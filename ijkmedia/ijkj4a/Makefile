# 这个 Makefile 是 ijkj4a 模块的 代码生成工具 ，它的主要作用是 自动从 Java 类文件生成对应的 JNI C 代码 ，而不是用于编译构建。这是一个 代码生成阶段的 Makefile 。

# 实际应用场景
# 开发阶段
# 1. 修改 Java 类的接口
# 2. 运行 make 重新生成 JNI 代码
# 3. 编译测试新的 JNI 接口
# 构建阶段
# 1. 使用已生成的 JNI 代码
# 2. Android.mk 直接编译这些代码
# 3. 链接到最终的播放器库

J4A = ../../extra/bin/j4a
ROOT_CLASS_INCLUDES = j4a/j4a_allclasses.include.h
ROOT_CLASS_LOADERS = j4a/j4a_allclasses.loader.h

all: ijkj4a

# test java -> c
JAVA_SRCS = \
	java/java/nio/Buffer.java \
	java/java/nio/ByteBuffer.java \
	java/java/util/ArrayList.java \
	java/android/media/AudioTrack.java \
	java/android/media/MediaCodec.java \
	java/android/media/MediaFormat.java \
	java/android/media/PlaybackParams.java \
	java/android/os/Build.java \
	java/android/os/Bundle.java \
	java/tv/danmaku/ijk/media/player/misc/IMediaDataSource.java \
	java/tv/danmaku/ijk/media/player/misc/IAndroidIO.java \
	java/tv/danmaku/ijk/media/player/IjkMediaPlayer.java \

C_SRCS := $(JAVA_SRCS:java/%.java=j4a/class/%.c)
H_SRCS := $(C_SRCS:%.c=%.h)

$(C_SRCS): j4a/class/%.c: $(J4A)

$(C_SRCS): j4a/class/%.c: java/%.java
ifneq ("$<", "j4a/class/.c")
	@mkdir -p $(shell dirname $@)
	$(J4A) -c $< -o $@
	@cat j4a/class/$*.include.j4a >> $(ROOT_CLASS_INCLUDES)
	@echo >> $(ROOT_CLASS_INCLUDES)
	@cat j4a/class/$*.loader.j4a >> $(ROOT_CLASS_LOADERS)
	@echo >> $(ROOT_CLASS_LOADERS)
endif

ijkj4a: prebuild $(C_SRCS)

prebuild:
	@rm -f $(ROOT_CLASS_INCLUDES)
	@rm -f $(ROOT_CLASS_LOADERS)

# -----
.PHONY: all clean ijkj4a prebuild

clean:
	@rm -f $(C_SRCS)
	@rm -f $(H_SRCS)
	@rm -f $(ROOT_CLASS_INCLUDES)
	@rm -f $(ROOT_CLASS_LOADERS)
