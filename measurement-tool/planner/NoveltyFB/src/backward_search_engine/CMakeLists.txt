target_sources(core
    PRIVATE
    bfws_forward_backward.hxx   rp_heuristic_bfws.hxx
)

target_include_directories(core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)

install(
    FILES
        ${PROJECT_SOURCE_DIR}/src/backward_search_engine/bfws_forward_backward.hxx
        ${PROJECT_SOURCE_DIR}/src/backward_search_engine/rp_heuristic_bfws.hxx
    DESTINATION
        ${CMAKE_INSTALL_PREFIX}/lapkt/core/include/backward_search_engine
    COMPONENT
        lapkt 
)