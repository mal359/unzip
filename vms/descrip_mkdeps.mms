# DESCRIP_MKDEPS.MMS
#
#    UnZip 6.0 for VMS -- MMS Dependency Description File.
#    (Back-port from later Zip version.  See DESCRIP.MMS for details.)
#
#    Last revised:  2022-07-22
#
#----------------------------------------------------------------------
# Copyright (c) 2004-2022 Info-ZIP.  All rights reserved.
#
# See the accompanying file LICENSE, version 2009-Jan-2 or later (the
# contents of which are also included in zip.h) for terms of use.  If,
# for some reason, all these files are missing, the Info-ZIP license
# may also be found at: ftp://ftp.info-zip.org/pub/infozip/license.html
#----------------------------------------------------------------------
#
#    MMS /EXTENDED_SYNTAX description file to generate a C source
#    dependencies file.  Unsightly errors result when /EXTENDED_SYNTAX
#    is not specified.  Typical usage:
#
#    $ L_U = "BZIP2_SFX, USE_OWN_CRCTAB"
#    $ MMS /EXTEND /DESCRIP = [.VMS]DESCRIP_MKDEPS.MMS /SKIP -
#       /MACRO = (IZ_ZLIB=iz_zlib, "LOCAL_UNZIP=''L_U'")
#
# Note that this description file must be used from the main
# distribution directory, not from the [.VMS] subdirectory.
#
# This description file uses these command procedures:
#
#    [.VMS]MOD_DEP.COM
#    [.VMS]COLLECT_DEPS.COM
#
# MMK users without MMS will be unable to generate the dependencies file
# using this description file, however there should be one supplied in
# the kit.  If this file has been deleted, users in this predicament
# will need to recover it from the original distribution kit.
#
# Note:  This dependency generation scheme assumes that the dependencies
# do not depend on host architecture type or other such variables.
# Therefore, no "#include" directive in the C source itself should be
# conditional on such variables.
#
# The default target is the comprehensive source dependency file,
# DEPS_FILE = [.VMS]DESCRIP_DEPS.MMS.
#
# Other targets:
#
#    CLEAN      deletes the individual source dependency files,
#               *.MMSD;*, but leaves the comprehensive source dependency
#               file.
#
#    CLEAN_ALL  deletes all source dependency files, including the
#               individual *.MMSD;* files and the comprehensive file,
#               DESCRIP_DEPS.MMS.*.
#

# Required command procedures.

COLLECT_DEPS = [.VMS]COLLECT_DEPS.COM
MOD_DEP = [.VMS]MOD_DEP.COM

COMS = $(COLLECT_DEPS) $(MOD_DEP)

# Include the source file lists (among other data).

INCL_DESCRIP_SRC = 1
.INCLUDE [.VMS]DESCRIP_SRC.MMS

# The ultimate product, a comprehensive dependency list.

DEPS_FILE = [.VMS]DESCRIP_DEPS.MMS

# Detect valid qualifier and/or macro options.

.IF $(FINDSTRING Skip, $(MMSQUALIFIERS)) .eq Skip
DELETE_MMSD = 1
.ELSIF NOSKIP
PURGE_MMSD = 1
.ELSE
UNK_MMSD = 1
.ENDIF

# Dependency suffixes and rules.
#
# .FIRST is assumed to be used already, so the MMS qualifier/macro check
# is included in each rule (one way or another).

.SUFFIXES_BEFORE .C .MMSD

.C.MMSD :
.IF UNK_MMSD
	@ write sys$output -
 "   /SKIP_INTERMEDIATES is expected on the MMS command line."
	@ write sys$output -
 "   For normal behavior (delete .MMSD files), specify ""/SKIP""."
	@ write sys$output -
 "   To retain the .MMSD files, specify ""/MACRO = NOSKIP=1""."
	@ exit %x00000004
.ENDIF
	$(CC) $(CFLAGS_DEP) $(CDEFS_UNX) $(MMS$SOURCE) $(CFLAGS_LIST) -
         /NOOBJECT /MMS_DEPENDENCIES = (FILE = $(MMS$TARGET), -
         NOSYSTEM_INCLUDE_FILES)

# List of MMS dependency files.

# In case it's not obvious...
# To extract module name lists from object library module=object lists:
# 1.  Transform "module=[.dest]name.OBJ" into "module=[.dest] name".
# 2.  For [.VMS], add [.VMS] to name.
# 3.  Delete "*]" words.
#
# A similar scheme works for executable lists.

MODS_LIB_UNZIP_N = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] *, $(MODS_OBJS_LIB_UNZIP_N)))

MODS_LIB_UNZIP_V = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] [.VMS]*, $(MODS_OBJS_LIB_UNZIP_V)))

MODS_LIB_UNZIP_AES = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] [.AES_WG]*, $(MODS_OBJS_LIB_UNZIP_AES)))

MODS_LIB_UNZIP_LZMA = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] [.LZMA]*, $(MODS_OBJS_LIB_UNZIP_LZMA)))

MODS_LIB_UNZIP_PPMD = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] [.PPMD]*, $(MODS_OBJS_LIB_UNZIP_PPMD)))

MODS_LIB_UNZIPCLI_N = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] *, $(MODS_OBJS_LIB_UNZIPCLI_C_N)))

MODS_LIB_UNZIPCLI_V = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] [.VMS]*, $(MODS_OBJS_LIB_UNZIPCLI_C_V)))

MODS_LIB_UNZIPSFX_N = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] *, $(MODS_OBJS_LIB_UNZIPSFX_N)))

MODS_LIB_UNZIPSFX_V = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] [.VMS]*, $(MODS_OBJS_LIB_UNZIPSFX_V)))

MODS_LIB_LIBUNZIP_NL = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] *, $(MODS_OBJS_LIB_LIBUNZIP_NL)))

MODS_LIB_LIBUNZIP_V = $(FILTER-OUT *], \
 $(PATSUBST *]*.OBJ, *] [.VMS]*, $(MODS_OBJS_LIB_LIBUNZIP_V)))

MODS_UNZIP = $(FILTER-OUT *], \
 $(PATSUBST *]*.EXE, *] *, $(UNZIP)))

MODS_UNZIP_CLI = $(FILTER-OUT *], \
 $(PATSUBST *]*.EXE, *] *, $(UNZIP_CLI)))

MODS_UNZIPSFX = $(FILTER-OUT *], \
 $(PATSUBST *]*.EXE, *] *, $(UNZIPSFX)))

MODS_UNZIPSFX_CLI = $(FILTER-OUT *], \
 $(PATSUBST *]*.EXE, *] *, $(UNZIPSFX_CLI)))

# Complete list of C object dependency file names.
# Note that the CLI UnZip main program object file is a special case.

DEPS = $(FOREACH NAME, \
 $(MODS_LIB_UNZIP_N) $(MODS_LIB_UNZIP_V) \
 $(MODS_LIB_UNZIP_AES) \
 $(MODS_LIB_UNZIP_LZMA) \
 $(MODS_LIB_UNZIP_PPMD) \
 $(MODS_LIB_UNZIPCLI_N) $(MODS_LIB_UNZIPCLI_V) \
 $(MODS_LIB_UNZIPSFX_N) $(MODS_LIB_UNZIPSFX_V) \
 $(MODS_UNZIP) $(MODS_UNZIP_CLI) \
 $(MODS_UNZIPSFX) $(MODS_UNZIPSFX_CLI) \
 $(MODS_LIB_LIBUNZIP_NL), \
 $(NAME).MMSD)

# Default target is the comprehensive dependency list.

$(DEPS_FILE) : $(DEPS) $(COMS)
.IF UNK_MMSD
	@ write sys$output -
 "   /SKIP_INTERMEDIATES is expected on the MMS command line."
	@ write sys$output -
 "   For normal behavior (delete individual .MMSD files), specify ""/SKIP""."
	@ write sys$output -
 "   To retain the individual .MMSD files, specify ""/MACRO = NOSKIP=1""."
	@ exit %x00000004
.ENDIF
#
#       Note that the space in P4, which prevents immediate macro
#       expansion, is removed by COLLECT_DEPS.COM.
#
	@$(COLLECT_DEPS) "UnZip for VMS" "$(MMS$TARGET)" -
         "[...]*.MMSD" "[.$ (DEST)]" $(MMSDESCRIPTION_FILE) -
         "[.AES_WG/[.LZMA]/[.PPMD]" -
         "AES_WG/LZMA/PPMD"
	@ write sys$output -
         "Created a new dependency file: $(MMS$TARGET)"
.IF DELETE_MMSD
	@ write sys$output -
         "Deleting intermediate .MMSD files..."
	if (f$search( "*.MMSD") .nes. "") then -
         delete /log *.MMSD;*
	if (f$search( "[.aes_wg]*.MMSD") .nes. "") then -
         delete /log [.aes_wg]*.MMSD;*
	if (f$search( "[.lzma]*.MMSD") .nes. "") then -
         delete /log [.lzma]*.MMSD;*
	if (f$search( "[.ppmd]*.MMSD") .nes. "") then -
         delete /log [.ppmd]*.MMSD;*
	if (f$search( "[.VMS]*.MMSD") .nes. "") then -
         delete /log [.VMS]*.MMSD;*
.ELSE
	@ write sys$output -
         "Purging intermediate .MMSD files..."
	if (f$search( "*.MMSD;-1") .nes. "") then -
         purge /log *.MMSD
	if (f$search( "[.aes_wg]*.MMSD;-1") .nes. "") then -
         purge /log [.aes_wg]*.MMSD
	if (f$search( "[.lzma]*.MMSD;-1") .nes. "") then -
         purge /log [.lzma]*.MMSD
	if (f$search( "[.ppmd]*.MMSD;-1") .nes. "") then -
         purge /log [.ppmd]*.MMSD
	if (f$search( "[.VMS]*.MMSD;-1") .nes. "") then -
         purge /log [.VMS]*.MMSD
.ENDIF

# CLEAN target.  Delete the individual C dependency files.

CLEAN :
	if (f$search( "*.MMSD") .nes. "") then -
         delete /log *.MMSD;*
	if (f$search( "[.aes_wg]*.MMSD") .nes. "") then -
         delete /log [.aes_wg]*.MMSD;*
	if (f$search( "[.lzma]*.MMSD") .nes. "") then -
         delete /log [.lzma]*.MMSD;*
	if (f$search( "[.ppmd]*.MMSD") .nes. "") then -
         delete /log [.ppmd]*.MMSD;*
	if (f$search( "[.VMS]*.MMSD") .nes. "") then -
         delete /log [.VMS]*.MMSD;*

# CLEAN_ALL target.  Delete:
#    The individual C dependency files.
#    The collected source dependency file.

CLEAN_ALL :
	if (f$search( "*.MMSD") .nes. "") then -
         delete /log *.MMSD;*
	if (f$search( "[.aes_wg]*.MMSD") .nes. "") then -
         delete /log [.aes_wg]*.MMSD;*
	if (f$search( "[.lzma]*.MMSD") .nes. "") then -
         delete /log [.lzma]*.MMSD;*
	if (f$search( "[.ppmd]*.MMSD") .nes. "") then -
         delete /log [.ppmd]*.MMSD;*
	if (f$search( "[.VMS]*.MMSD") .nes. "") then -
         delete /log [.VMS]*.MMSD;*
	if (f$search( "[.VMS]DESCRIP_DEPS.MMS") .nes. "") then -
         delete /log [.VMS]DESCRIP_DEPS.MMS;*

# Explicit dependencies and rules for utility variant modules.
#
# The extra dependency on the normal dependency file obviates including
# the /SKIP warning code in each rule here.

CRC32_.MMSD : CRC32.C CRC32.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

CRYPT_.MMSD : CRYPT.C CRYPT.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

EXTRACT_.MMSD : EXTRACT.C EXTRACT.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

FILEIO_.MMSD : FILEIO.C FILEIO.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

GLOBALS_.MMSD : GLOBALS.C GLOBALS.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

ICONV_MAP_.MMSD : ICONV_MAP.C ICONV_MAP.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

IF_LZMA_.MMSD : IF_LZMA.C IF_LZMA.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

IF_PPMD_.MMSD : IF_PPMD.C IF_PPMD.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

INFLATE_.MMSD : INFLATE.C INFLATE.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

MATCH_.MMSD : MATCH.C MATCH.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

PROCESS_.MMSD : PROCESS.C PROCESS.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

TTYIO_.MMSD : TTYIO.C TTYIO.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

UBZ2ERR_.MMSD : UBZ2ERR.C UBZ2ERR.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

[.VMS]VMS_.MMSD : [.VMS]VMS.C [.VMS]VMS.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

UNZIP_CLI.MMSD : UNZIP.C UNZIP.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

UNZIPSFX.MMSD : UNZIP.C UNZIP.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_SFX) $(CDEFS_SFX) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

UNZIPSFX_CLI.MMSD : UNZIP.C UNZIP.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CFLAGS_SFX) $(CDEFS_SFX_CLI) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

ZIPINFO_C.MMSD : ZIPINFO.C ZIPINFO.MMSD
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

# Special case.  No normal (non-CLI) version.

[.VMS]CMDLINE.MMSD : [.VMS]CMDLINE.C
.IF UNK_MMSD
	@ write sys$output -
 "   /SKIP_INTERMEDIATES is expected on the MMS command line."
	@ write sys$output -
 "   For normal behavior (delete .MMSD files), specify ""/SKIP""."
	@ write sys$output -
 "   To retain the .MMSD files, specify ""/MACRO = NOSKIP=1""."
	@ exit %x00000004
.ENDIF
	$(CC) $(CFLAGS_DEP) $(CFLAGS_CLI) $(CDEFS_CLI) $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

# UnZip library modules.

APIHELP_L.MMSD : APIHELP.C
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

API_L.MMSD : API.C API.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

CRYPT_L.MMSD : CRYPT.C CRYPT.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

EXPLODE_L.MMSD : EXPLODE.C EXPLODE.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

EXTRACT_L.MMSD : EXTRACT.C EXTRACT.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

FILEIO_L.MMSD : FILEIO.C FILEIO.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

GLOBALS_L.MMSD : GLOBALS.C GLOBALS.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

ICONV_MAP_L.MMSD : ICONV_MAP.C ICONV_MAP.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

IF_LZMA_L.MMSD : IF_LZMA.C IF_LZMA.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

IF_PPMD_L.MMSD : IF_PPMD.C IF_PPMD.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

INFLATE_L.MMSD : INFLATE.C INFLATE.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

LIST_L.MMSD : LIST.C LIST.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

PROCESS_L.MMSD : PROCESS.C PROCESS.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

TTYIO_L.MMSD : TTYIO.C TTYIO.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

UBZ2ERR_L.MMSD : UBZ2ERR.C UBZ2ERR.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

UNSHRINK_L.MMSD : UNSHRINK.C UNSHRINK.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

UNZIP_L.MMSD : UNZIP.C UNZIP.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

[.VMS]VMS_L.MMSD : [.VMS]VMS.C [.VMS]VMS.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

ZIPINFO_L.MMSD : ZIPINFO.C ZIPINFO.MMSD
	$(CC) $(CFLAGS_DEP) $(CDEFS_LIBUNZIP) -
         $(MMS$SOURCE) -
         $(CFLAGS_LIST) /NOOBJECT /MMS_DEPENDENCIES = -
         (FILE = $(MMS$TARGET), NOSYSTEM_INCLUDE_FILES)
	@$(MOD_DEP) $(MMS$TARGET) $(MMS$TARGET_NAME).OBJ $(MMS$TARGET)

