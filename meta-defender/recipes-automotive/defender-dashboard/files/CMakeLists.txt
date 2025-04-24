cmake_minimum_required(VERSION 3.16)
project(defender-dashboard LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Core Quick QuickControls2 WebSockets REQUIRED)

set(PROJECT_SOURCES
    src/main.cpp
    src/dashboardcontroller.h
    src/dashboardcontroller.cpp
    src/resources.qrc
)

qt_add_executable(defender-dashboard
    ${PROJECT_SOURCES}
)

target_link_libraries(defender-dashboard PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::WebSockets
)

install(TARGETS defender-dashboard
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)