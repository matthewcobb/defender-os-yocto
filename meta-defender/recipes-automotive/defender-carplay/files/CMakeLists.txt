cmake_minimum_required(VERSION 3.16)
project(defender-carplay LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 COMPONENTS Core Quick REQUIRED)

set(PROJECT_SOURCES
    src/main.cpp
    src/resources.qrc
)

qt_add_executable(defender-carplay
    ${PROJECT_SOURCES}
)

target_link_libraries(defender-carplay PRIVATE Qt6::Core Qt6::Quick)

install(TARGETS defender-carplay DESTINATION ${CMAKE_INSTALL_BINDIR})