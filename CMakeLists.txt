cmake_minimum_required(VERSION 4.0)
project(ces)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(SDLTTF_VENDORED ON)
set(FETCHCONTENT_BASE_DIR ${CMAKE_SOURCE_DIR}/deps)

include(FetchContent)

find_package(SDL3 QUIET)
if (NOT TARGET SDL3::SDL3)
    FetchContent_Declare(
        SDL3
        GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
        GIT_TAG release-3.4.0
        GIT_SHALLOW TRUE
    )
    FetchContent_MakeAvailable(SDL3)
endif()

find_package(SDL3_ttf QUIET)
if (NOT TARGET SDL3_ttf::SDL3_ttf)
    FetchContent_Declare(
        SDL3_ttf
        GIT_REPOSITORY https://github.com/libsdl-org/SDL_ttf.git
        GIT_TAG release-3.2.x
        GIT_SHALLOW TRUE
    )
    FetchContent_MakeAvailable(SDL3_ttf)
endif()

if(WIN32)
  add_executable(${PROJECT_NAME} WIN32 src/unity_build.cpp)
else()
  add_executable(${PROJECT_NAME} src/unity_build.cpp)
endif()

if(MSVC)
  target_compile_options(${PROJECT_NAME} PRIVATE 
    /W4 
    /WX 
    /wd4710
    /wd4711
  )
else()
  # GCC/Clang
  target_compile_options(${PROJECT_NAME} PRIVATE
    -Wall
    -Wextra
    -Werror
    -Weffc++
    -Wconversion
    -Wsign-conversion
    -Wimplicit-int-float-conversion
  )
endif()

target_link_libraries(${PROJECT_NAME} 
    SDL3::SDL3
    SDL3_ttf::SDL3_ttf
)

add_custom_command(TARGET ces POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:SDL3::SDL3>
        $<TARGET_FILE_DIR:ces>
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:SDL3_ttf::SDL3_ttf>
        $<TARGET_FILE_DIR:ces>
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/asset/
        $<TARGET_FILE_DIR:ces>/asset/
)
