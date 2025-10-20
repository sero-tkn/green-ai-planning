add_subdirectory(fwdbwd_approximate_bfws)


install(
    FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/fwdbwd_approximate_bfws/fwdbwd_approximate_bfws.hxx
    DESTINATION
        ${CMAKE_INSTALL_PREFIX}/${REL_CORE_INC_DIR}/planner
    COMPONENT
        lapkt
)