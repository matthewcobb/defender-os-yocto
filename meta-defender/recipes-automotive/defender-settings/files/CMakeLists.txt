cmake_minimum_required(VERSION 3.16)
project(defender-settings LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 COMPONENTS Core Quick QuickControls2 Svg REQUIRED)

set(PROJECT_SOURCES
    src/main.cpp
    src/resources.qrc
)

qt_add_executable(defender-settings
    ${PROJECT_SOURCES}
)

target_link_libraries(defender-settings PRIVATE Qt6::Core Qt6::Quick Qt6::QuickControls2 Qt6::Svg)

install(TARGETS defender-settings DESTINATION ${CMAKE_INSTALL_BINDIR})