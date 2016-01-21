@echo off
setlocal
pushd %~dp0

rem install mingw-gcc 5.3+ (http://files.1f0.de/mingw/) and append PATH with mingw/bin
rem install yasm 1.3+ (http://www.tortall.net/projects/yasm/wiki/Download) and append PATH

set FFMC_FILES= ^
    libavutil\buffer.c ^
    libavutil\cpu.c ^
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

set FFMP_FILES= ^
    libavutil\x86\cpu.c ^
    libavcodec\x86\hevcdsp_init.c ^
    libavcodec\x86\constants.c

set FFMA_FILES= ^
    libavutil\x86\cpuid.asm ^
    libavcodec\x86\hevc_deblock.asm ^
    libavcodec\x86\hevc_idct.asm ^
    libavcodec\x86\hevc_mc.asm ^
    libavcodec\x86\hevc_res_add.asm

set FFMO_FILES= ^
    cpuid.obj ^
    hevc_deblock.obj ^
    hevc_idct.obj ^
    hevc_mc.obj ^
    hevc_res_add.obj

set DEC_FILES= ^
    libbpg.c ^
    bpgdec.c

set CL_FLAGS=-DHAVE_AV_CONFIG_H -DCONFIG_BPG_VERSION=\^"0.9.6-dwing\^" -D__USE_MINGW_ANSI_STDIO=1 -I. -Ofast -ffast-math -fweb -fomit-frame-pointer -fmerge-all-constants -pipe -static -s
set CL_32=i686-w64-mingw32-gcc.exe -m32 -march=i686 %CL_FLAGS% -flto -fwhole-program
set CL_64=x86_64-w64-mingw32-gcc.exe -m64 %CL_FLAGS%

echo building bpgdec.exe ...
rem %CL_32% -DARCH_X86=0 -DARCH_X86_32=0 -DARCH_X86_64=0 -o bpgdec.exe %FFMC_FILES% %DEC_FILES%

echo building bpgdec_x86.exe ...
set YASM_PARAMS=yasm -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 -I. --prefix=_ -a x86 -m x86 -f win32 -P config.asm
rem %YASM_PARAMS% libavutil\x86\cpuid.asm
rem %YASM_PARAMS% libavcodec\x86\hevc_deblock.asm
rem %YASM_PARAMS% libavcodec\x86\hevc_idct.asm
rem %YASM_PARAMS% libavcodec\x86\hevc_mc.asm
rem %YASM_PARAMS% libavcodec\x86\hevc_res_add.asm
rem %CL_32% -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 -o bpgdec_x86.exe %FFMC_FILES% %FFMP_FILES% %DEC_FILES% %FFMO_FILES%

echo building bpgdec_x64.exe ...
set YASM_PARAMS=yasm -DARCH_X86=1 -DARCH_X86_32=0 -DARCH_X86_64=1 -I. --prefix=_ -a x86 -m amd64 -f win64 -P config.asm
%YASM_PARAMS% libavutil\x86\cpuid.asm
%YASM_PARAMS% libavcodec\x86\hevc_deblock.asm
%YASM_PARAMS% libavcodec\x86\hevc_idct.asm
%YASM_PARAMS% libavcodec\x86\hevc_mc.asm
%YASM_PARAMS% libavcodec\x86\hevc_res_add.asm
%CL_64% -DARCH_X86=1 -DARCH_X86_32=0 -DARCH_X86_64=1 -o bpgdec_x64.exe %FFMC_FILES% %FFMP_FILES% %DEC_FILES% %FFMO_FILES%

pause
