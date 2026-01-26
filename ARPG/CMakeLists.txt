cmake_minimum_required(VERSION 3.10)
project(IsoARPG)

# 設定 C++ 標準為 C++17 (為了更現代的語法支援)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# 尋找 SFML 套件
find_package(SFML 2.5 COMPONENTS graphics window system REQUIRED)

# 加入原始碼檔案 (目前只有 main.cpp)
add_executable(IsoARPG main.cpp)

# 連結 SFML 函式庫
target_link_libraries(IsoARPG sfml-graphics sfml-window sfml-system)
