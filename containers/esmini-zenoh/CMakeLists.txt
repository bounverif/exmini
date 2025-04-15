cmake_minimum_required(VERSION 3.10)

project(esmini-zenoh)

find_package(zenohc) #if using zenoh-c backend
find_package(zenohcxx)

add_executable(esmini_zenoh esmini_zenoh.cpp)

target_link_libraries(esmini_zenoh PUBLIC zenohcxx::zenohc)
