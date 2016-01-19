@echo off
setlocal
pushd %~dp0

rem install mingw-gcc 5.3+ (http://files.1f0.de/mingw/) and append PATH with mingw/bin

set FFM_FILES= ^
    libavutil\buffer.c ^
    libavutil\frame.c ^
    libavutil\log2_tab.c ^
    libavutil\md5.c ^
    libavutil\mem.c ^
    libavutil\pixdesc.c ^
    libavcodec\cabac.c ^
    libavcodec\golomb.c ^
    libavcodec\hevc.c ^
    libavcodec\hevcdsp.c ^
    libavcodec\hevcpred.c ^
    libavcodec\hevc_cabac.c ^
    libavcodec\hevc_filter.c ^
    libavcodec\hevc_mvs.c ^
    libavcodec\hevc_ps.c ^
    libavcodec\hevc_refs.c ^
    libavcodec\hevc_sei.c ^
    libavcodec\utils.c ^
    libavcodec\videodsp.c

set DEC_FILES=libbpg.c bpgdec.c

set CL_FLAGS=-DHAVE_AV_CONFIG_H -DCONFIG_BPG_VERSION=\^"0.9.6-dwing\^" -D__USE_MINGW_ANSI_STDIO=1 -I. -Ofast -ffast-math -fweb -fomit-frame-pointer -fmerge-all-constants -pipe -static -pthread -lpthread -s
set CL_32=i686-w64-mingw32-gcc.exe -m32 -march=i686 -flto -fwhole-program %CL_FLAGS%
set CL_64=x86_64-w64-mingw32-gcc.exe -m64 %CL_FLAGS%

echo building bpgdec ...
    %CL_32% -o bpgdec.exe %FFM_FILES% %DEC_FILES%
rem %CL_64% -o bpgdec64.exe %FFM_FILES% %DEC_FILES%

pause
