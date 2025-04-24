cmake_minimum_required(VERSION 3.16)
project(defender-launcher LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 COMPONENTS Core Quick QuickControls2 REQUIRED)

set(PROJECT_SOURCES
    src/main.cpp
    src/resources.qrc
)

qt_add_executable(defender-launcher
    ${PROJECT_SOURCES}
)

target_link_libraries(defender-launcher PRIVATE Qt6::Core Qt6::Quick Qt6::QuickControls2)

install(TARGETS defender-launcher DESTINATION ${CMAKE_INSTALL_BINDIR})