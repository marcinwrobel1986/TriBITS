# @HEADER
# ************************************************************************
#
#            TriBITS: Tribal Build, Integrate, and Test System
#                    Copyright 2013 Sandia Corporation
#
# Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
# the U.S. Government retains certain rights in this software.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the Corporation nor the names of the
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ************************************************************************
# @HEADER

# Echo input arguments
message("PROJECT_NAME = '${PROJECT_NAME}'")
message("${PROJECT_NAME}_TRIBITS_DIR = '${${PROJECT_NAME}_TRIBITS_DIR}'")
message("CURRENT_TEST_DIRECTORY = '${CURRENT_TEST_DIRECTORY}'")

set( CMAKE_MODULE_PATH
  "${${PROJECT_NAME}_TRIBITS_DIR}/core/utils"
  "${${PROJECT_NAME}_TRIBITS_DIR}/core/package_arch"
  )

include(TribitsExternalPackageWriteConfigFile)

include(UnitTestHelpers)
include(GlobalNullSet)


#####################################################################
#
# Unit tests for code in TribitsExternalPackageWriteConfigFile.cmake
#
#####################################################################


#
# Tests for tribits_external_package_process_libraries_list_incl()
#


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_files_1)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::somelib"
    )

  unittest_compare_const( libLinkFlagsList
    ""
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_files_2)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, lib files 2")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    "/some/explicit/path/libsomelib2.so" "/some/explicit/path/libsomelib1.so")

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::somelib1;SomeTpl::somelib2"
    )

  unittest_compare_const( libLinkFlagsList
    ""
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::somelib1 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib1 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib1.so")

add_library(SomeTpl::somelib2 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib2 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib2.so")
target_link_libraries(SomeTpl::somelib2
  INTERFACE SomeTpl::somelib1)

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_files_3)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, lib files 3")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    "/some/explicit/path/libsomelib3.so"
    "/some/explicit/path/libsomelib2.so"
    "/some/explicit/path/libsomelib1.so")

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::somelib1;SomeTpl::somelib2;SomeTpl::somelib3"
    )

  unittest_compare_const( libLinkFlagsList
    ""
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::somelib1 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib1 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib1.so")

add_library(SomeTpl::somelib2 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib2 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib2.so")
target_link_libraries(SomeTpl::somelib2
  INTERFACE SomeTpl::somelib1)

add_library(SomeTpl::somelib3 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib3 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib3.so")
target_link_libraries(SomeTpl::somelib3
  INTERFACE SomeTpl::somelib2)

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_1_1)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, lib opts 1, 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    -llib1 -L/some/explicit/path
    )

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::lib1"
    )

  unittest_compare_const( libLinkFlagsList
    "-L/some/explicit/path"
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::lib1 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib1 PROPERTIES
  IMPORTED_LIBNAME "lib1")

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_2_2)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, lib opts 2, 2")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    -llib2 -L/some/explicit/path2
    -llib1 -L/some/explicit/path1
    )

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::lib1;SomeTpl::lib2"
    )

  unittest_compare_const( libLinkFlagsList
    "-L/some/explicit/path2;-L/some/explicit/path1"
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::lib1 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib1 PROPERTIES
  IMPORTED_LIBNAME "lib1")

add_library(SomeTpl::lib2 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib2 PROPERTIES
  IMPORTED_LIBNAME "lib2")
target_link_libraries(SomeTpl::lib2
  INTERFACE SomeTpl::lib1)

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_3_3)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, lib opts 3, 3")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    -llib3 -L/some/explicit/path3
    -llib2 -L/some/explicit/path2
    -llib1 -L/some/explicit/path1
    )

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::lib1;SomeTpl::lib2;SomeTpl::lib3"
    )

  unittest_compare_const( libLinkFlagsList
    "-L/some/explicit/path3;-L/some/explicit/path2;-L/some/explicit/path1"
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::lib1 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib1 PROPERTIES
  IMPORTED_LIBNAME "lib1")

add_library(SomeTpl::lib2 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib2 PROPERTIES
  IMPORTED_LIBNAME "lib2")
target_link_libraries(SomeTpl::lib2
  INTERFACE SomeTpl::lib1)

add_library(SomeTpl::lib3 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib3 PROPERTIES
  IMPORTED_LIBNAME "lib3")
target_link_libraries(SomeTpl::lib3
  INTERFACE SomeTpl::lib2)

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_link_opt_1)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, link opt 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES "-mkl")

  set(configFileFragStr "#beginning\n\n")

  set(MESSAGE_WRAPPER_UNIT_TEST_MODE ON)
  global_null_set(MESSAGE_WRAPPER_INPUT)

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( MESSAGE_WRAPPER_INPUT
    "-- NOTE: Moving the general link argument '-mkl' in TPL_${tplName}_LIBRARIES forward on the link line which may change the link and break the link!"
    )

  unittest_compare_const( libTargetsList
    ""
    )

  unittest_compare_const( libLinkFlagsList
    "-mkl"
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_libname_2)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, libname 2")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    some1_Longer2-Name3  # Lower case, upper case, _, -, and digits
    -   # One-char special case that should never happen
    c   # One-char special case like 'm'
    )

  set(configFileFragStr "#beginning\n\n")

  set(MESSAGE_WRAPPER_UNIT_TEST_MODE ON)
  global_null_set(MESSAGE_WRAPPER_INPUT)

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( MESSAGE_WRAPPER_INPUT
    "-- NOTE: Moving the general link argument '-' in TPL_SomeTpl_LIBRARIES forward on the link line which may change the link and break the link!"
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::c;SomeTpl::some1_Longer2-Name3"
    )

  unittest_compare_const( libLinkFlagsList "-" )

  message("configFileFragStr:\n\n${configFileFragStr}")

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::c IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::c PROPERTIES
  IMPORTED_LIBNAME "c")

add_library(SomeTpl::some1_Longer2-Name3 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::some1_Longer2-Name3 PROPERTIES
  IMPORTED_LIBNAME "some1_Longer2-Name3")
target_link_libraries(SomeTpl::some1_Longer2-Name3
  INTERFACE SomeTpl::c)

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_2_2_lib_files_1)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): incl dirs 0, lib opts 2, 2, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    -llib3 -L/some/explicit/path3
    /some/other/path/to/libsomelib.a
    -llib1 -L/some/explicit/path1
    )

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::lib1;SomeTpl::somelib;SomeTpl::lib3"
    )

  unittest_compare_const( libLinkFlagsList
    "-L/some/explicit/path3;-L/some/explicit/path1"
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::lib1 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib1 PROPERTIES
  IMPORTED_LIBNAME "lib1")

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/other/path/to/libsomelib.a")
target_link_libraries(SomeTpl::somelib
  INTERFACE SomeTpl::lib1)

add_library(SomeTpl::lib3 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib3 PROPERTIES
  IMPORTED_LIBNAME "lib3")
target_link_libraries(SomeTpl::lib3
  INTERFACE SomeTpl::somelib)

]=]
    )

endfunction()


function(unittest_tribits_external_package_process_libraries_list_duplicate_libs)

  message("\n***")
  message("*** Testing tribits_external_package_process_libraries_list(): duplicate libs")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    -llib3 -L/some/explicit/path3
    /some/other/path/to/libsomelib.a
    -llib3 -L/some/explicit/path3
    /some/other/path/to/libsomelib.a
    -llib1 -L/some/explicit/path1
    )

  set(configFileFragStr "#beginning\n\n")

  tribits_external_package_process_libraries_list( ${tplName}
    LIB_TARGETS_LIST_OUT libTargetsList
    LIB_LINK_FLAGS_LIST_OUT libLinkFlagsList
    CONFIG_FILE_STR_INOUT configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::lib1;SomeTpl::somelib;SomeTpl::lib3"
    )

  unittest_compare_const( libLinkFlagsList
    "-L/some/explicit/path3;-L/some/explicit/path3;-L/some/explicit/path1"
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::lib1 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib1 PROPERTIES
  IMPORTED_LIBNAME "lib1")

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/other/path/to/libsomelib.a")
target_link_libraries(SomeTpl::somelib
  INTERFACE SomeTpl::lib1)

add_library(SomeTpl::lib3 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib3 PROPERTIES
  IMPORTED_LIBNAME "lib3")
target_link_libraries(SomeTpl::lib3
  INTERFACE SomeTpl::somelib)

]=]
    )

endfunction()


#
# Tests for tribits_external_package_write_config_file_str()
#


function(unittest_tribits_external_package_write_config_file_str_incl_dirs_0_lib_files_1)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 0, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "")
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  tribits_external_package_write_config_file_str(${tplName}
    tplConfigFileStr )

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::somelib
  )

]=]
    )

endfunction()


function(unittest_tribits_external_package_write_config_file_str_incl_dirs_2_lib_files_0)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 2, lib files 0")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "/some/path/to/include/d" "/some/other/path/to/include/e")
  set(TPL_${tplName}_LIBRARIES "")

  tribits_external_package_write_config_file_str(${tplName}
    tplConfigFileStr )

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_include_directories(SomeTpl::all_libs SYSTEM
  INTERFACE "/some/path/to/include/d"
  INTERFACE "/some/other/path/to/include/e"
  )

]=]
    )

endfunction()


function(unittest_tribits_external_package_write_config_file_str_incl_dirs_1_lib_files_1)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 1, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "/some/path/to/include/C")
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  tribits_external_package_write_config_file_str(${tplName}
    tplConfigFileStr )

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::somelib
  )
target_include_directories(SomeTpl::all_libs SYSTEM
  INTERFACE "/some/path/to/include/C"
  )

]=]
    )

endfunction()


function(unittest_tribits_external_package_write_config_file_str_incl_dirs_2_lib_files_1)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 2, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "/some/path/to/include/a" "/some/other/path/to/include/b")
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  tribits_external_package_write_config_file_str(${tplName}
    tplConfigFileStr )

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::somelib
  )
target_include_directories(SomeTpl::all_libs SYSTEM
  INTERFACE "/some/path/to/include/a"
  INTERFACE "/some/other/path/to/include/b"
  )

]=]
    )

endfunction()


function(unittest_tribits_external_package_write_config_file_str_incl_dirs_2_lib_opts_2_2)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 2, lib opts 2, 2")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS
    "/some/path/to/include/a"
    "/some/other/path/to/include/b")
  set(TPL_${tplName}_LIBRARIES
    -llib2 -L/some/explicit/path2
    -llib1 -L/some/explicit/path1
    )

  tribits_external_package_write_config_file_str(${tplName}
    tplConfigFileStr )

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::lib1 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib1 PROPERTIES
  IMPORTED_LIBNAME "lib1")

add_library(SomeTpl::lib2 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib2 PROPERTIES
  IMPORTED_LIBNAME "lib2")
target_link_libraries(SomeTpl::lib2
  INTERFACE SomeTpl::lib1)

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::lib1
  INTERFACE SomeTpl::lib2
  )
target_include_directories(SomeTpl::all_libs SYSTEM
  INTERFACE "/some/path/to/include/a"
  INTERFACE "/some/other/path/to/include/b"
  )
target_link_options(SomeTpl::all_libs
  INTERFACE "-L/some/explicit/path2"
  INTERFACE "-L/some/explicit/path1"
  )

]=]
    )

endfunction()


function(unittest_tribits_external_package_write_config_file_str_incl_dirs_1_bad_lib_args)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 1, bad lib args")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS
    "/some/path/to/include/a"
    )
  set(TPL_${tplName}_LIBRARIES
    -llib2 -L/some/explicit/path2
    -o some-other-option
    some=nonsupported-opt
    -llib1 -L/some/explicit/path1
    )

  set(MESSAGE_WRAPPER_UNIT_TEST_MODE ON)
  global_null_set(MESSAGE_WRAPPER_INPUT)

  tribits_external_package_write_config_file_str(${tplName}
    tplConfigFileStr )

  unittest_compare_const( MESSAGE_WRAPPER_INPUT
    "SEND_ERROR;ERROR: Can't handle argument 'some=nonsupported-opt' in list TPL_SomeTpl_LIBRARIES;-- NOTE: Moving the general link argument '-o' in TPL_SomeTpl_LIBRARIES forward on the link line which may change the link and break the link!"
    )

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::lib1 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib1 PROPERTIES
  IMPORTED_LIBNAME "lib1")

add_library(SomeTpl::some-other-option IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::some-other-option PROPERTIES
  IMPORTED_LIBNAME "some-other-option")
target_link_libraries(SomeTpl::some-other-option
  INTERFACE SomeTpl::lib1)

add_library(SomeTpl::lib2 IMPORTED INTERFACE GLOBAL)
set_target_properties(SomeTpl::lib2 PROPERTIES
  IMPORTED_LIBNAME "lib2")
target_link_libraries(SomeTpl::lib2
  INTERFACE SomeTpl::some-other-option)

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::lib1
  INTERFACE SomeTpl::some-other-option
  INTERFACE SomeTpl::lib2
  )
target_include_directories(SomeTpl::all_libs SYSTEM
  INTERFACE "/some/path/to/include/a"
  )
target_link_options(SomeTpl::all_libs
  INTERFACE "-L/some/explicit/path2"
  INTERFACE "-o"
  INTERFACE "-L/some/explicit/path1"
  )

]=]
    )

endfunction()


#####################################################################
#
# Execute the unit tests
#
#####################################################################

unittest_initialize_vars()

#
# Run the unit tests
#

unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_files_1()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_files_2()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_files_3()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_1_1()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_2_2()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_3_3()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_lib_opts_2_2_lib_files_1()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_link_opt_1()
unittest_tribits_external_package_process_libraries_list_incl_dirs_0_libname_2()
unittest_tribits_external_package_process_libraries_list_duplicate_libs()

unittest_tribits_external_package_write_config_file_str_incl_dirs_0_lib_files_1()
unittest_tribits_external_package_write_config_file_str_incl_dirs_2_lib_files_0()
unittest_tribits_external_package_write_config_file_str_incl_dirs_1_lib_files_1()
unittest_tribits_external_package_write_config_file_str_incl_dirs_2_lib_files_1()
unittest_tribits_external_package_write_config_file_str_incl_dirs_2_lib_opts_2_2()
unittest_tribits_external_package_write_config_file_str_incl_dirs_1_bad_lib_args()

# Pass in the number of expected tests that must pass!
unittest_final_result(39)
