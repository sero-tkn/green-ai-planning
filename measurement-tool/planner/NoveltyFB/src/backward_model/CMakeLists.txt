target_sources(core 
    PRIVATE
    bwd_action.cxx          bwd_landmark_graph.cxx            bwd_landmark_graph_manager.hxx  bwd_match_tree.hxx         bwd_reachability.hxx  bwd_strips_prob.cxx   bwd_strips_state.hxx  bwd_fwd_search_prob.hxx
    bwd_action.hxx          bwd_landmark_graph_generator.hxx  bwd_layered_h_max.hxx           bwd_novelty_partition.hxx  bwd_search_prob.cxx   bwd_strips_prob.hxx
    bwd_landmark_count.hxx  bwd_landmark_graph.hxx            bwd_match_tree.cxx              bwd_reachability.cxx       bwd_search_prob.hxx   bwd_strips_state.cxx  bwd_fwd_search_prob.cxx
    negation_action.cxx     negation_action.hxx               negation_fluent.cxx             negation_fluent.hxx      bwd_mutex_set.cxx    bwd_mutex_set.hxx    bwd_succ_gen.cxx   bwd_succ_gen.hxx 
    bwd_types.hxx bwd_fluent.cxx bwd_fluent.hxx  bwd_cond_eff.cxx  bwd_cond_eff.hxx bwd_h_2.hxx base_search_prob.hxx bwd_open_list.hxx
)

target_include_directories(core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)


install(
    FILES
    bwd_action.hxx          bwd_landmark_graph_generator.hxx  bwd_landmark_graph_manager.hxx  bwd_match_tree.hxx         bwd_reachability.hxx  bwd_strips_prob.hxx   bwd_fwd_search_prob.hxx
    bwd_landmark_count.hxx  bwd_landmark_graph.hxx            bwd_layered_h_max.hxx           bwd_novelty_partition.hxx  bwd_search_prob.hxx   bwd_strips_state.hxx
    negation_action.hxx     negation_fluent.hxx   bwd_mutex_set.hxx    bwd_succ_gen.hxx  bwd_types.hxx bwd_fluent.hxx  bwd_cond_eff.hxx bwd_h_2.hxx  base_search_prob.hxx

    DESTINATION
        ${CMAKE_INSTALL_PREFIX}/lapkt/core/include/model
    COMPONENT
        lapkt 
)