# Copyright (c) 2017 VMware, Inc. All Rights Reserved.
# SPDX-License-Identifier: GPL-2.0

# We want to work on Ubuntu 16 LTS which uses CMake 3.5.
cmake_minimum_required (VERSION 3.5)

project(chap LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)

include(CTest)

# set where to find additional cmake modules if any
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

# chap

find_package(Replxx)

add_executable(chap src/FileAnalyzer.cpp)
target_compile_definitions(chap
                           PRIVATE $<$<BOOL:${REPLXX_FOUND}>:WITH_REPLXX>)

# An expectation here is that if Replxx is found, the library will be static
# linked. This is not enforced by the find module but it is desirable to make
# it easier to distribute the chap binary.
# It happens to work at present because the default build for Replxx
# produces only a static library.
target_link_libraries(chap
                      PRIVATE $<$<BOOL:${REPLXX_FOUND}>:Replxx::Replxx>)
install(TARGETS chap DESTINATION bin)

# Tests

add_subdirectory(test/expectedOutput)

# Add a 'check' target that depends on chap and dumps output on failure. It
# seems like this should be possible without a custom target, but attempts to
# use CTEST_OUTPUT_ON_FAILURE failed, as did attempts set DEPENDS on the tests
# directly.

if (CMAKE_CONFIGURATION_TYPES)
    add_custom_target(check
        COMMAND ${CMAKE_CTEST_COMMAND}
            --force-new-ctest-process --output-on-failure
            --build-config "$<CONFIGURATION>"
        DEPENDS chap
    )
else()
    add_custom_target(check
        COMMAND ${CMAKE_CTEST_COMMAND}
            --force-new-ctest-process --output-on-failure
        DEPENDS chap
    )
endif()
