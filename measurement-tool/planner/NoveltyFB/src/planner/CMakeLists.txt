
file(WRITE ${PROJECT_BINARY_DIR}/${REL_PYPI_LAPKT_ROOT}/planner/lapkt_planner_config.yml "")

target_sources(planner PRIVATE planner_py_module.cxx)
# target_link_libraries(planner PUBLIC planner)
if(MACOS_BUILD)
    set_target_properties(planner PROPERTIES
        INSTALL_RPATH "/usr/local/Frameworks/"
    )
else()
    set_target_properties(planner PROPERTIES
        INSTALL_RPATH "${aCMAKE_INSTALL_RPATH}:$ORIGIN"
    )
endif()

add_subdirectory(approximate_novelty_search)

target_include_directories(planner
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)

# PUBLIC_HEADER files can be installed with 
#   install(<target> ...PUBLIC_HEADER DESTINATION ...)

# set_target_properties(planner PROPERTIES
#     PUBLIC_HEADER
# "${PROJECT_SOURCE_DIR}/src/planner/anytime_lapkt/anytime_lapkt.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/anytime_lapkt/ipc2014_rwa.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/at_bfs_f/at_bfsf_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/bfs_f/bfsf_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/bfws/bfws.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/brfs/brfs_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/bfws/bfws.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/delete-free-iw/dfiw_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/delete-free-siw/dfsiw_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/dfs_plus/dfs_plus_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/iw/iw_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/iw_plus/rp_iw_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/siw/siw_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/siw_plus/siw_plus_planner.hxx;\
# ${PROJECT_SOURCE_DIR}/src/planner/siw_plus-then-bfs_f/siw_plus_bfs_f.hxx"
# )

# Planner configuration file in Python Package
install(
    FILES ${PROJECT_BINARY_DIR}/${REL_PYPI_LAPKT_ROOT}/planner/lapkt_planner_config.yml
    DESTINATION ${REL_PYPI_LAPKT_ROOT}/planner
    COMPONENT PYPACKAGE EXCLUDE_FROM_ALL
)