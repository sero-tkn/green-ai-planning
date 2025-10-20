#include <fwdbwd_approximate_bfws.hxx>
#include <strips_state.hxx>
#include <string_conversions.hxx>
#include <memory.hxx>
#include <iostream>
#include <fstream>

using aptk::agnostic::Fwd_Search_Problem;

//---- Constructor ----------------------------------------------------------//
FwdBwd_Approximate_BFWS::FwdBwd_Approximate_BFWS()
  : 
  fwd_interface(STRIPS_Interface()),
  bwd_interface(STRIPS_Interface_Bwd()),
  m_log_filename(LOG_FILE), m_plan_filename(PLAN_FILE),
    m_M(32), m_max_novelty(MAX_NOVELTY), m_anytime(false), m_found_plan(false),
    m_cost(infty), m_cost_bound(infty), m_partition_size(0) {}
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

//---- Constructor ----------------------------------------------------------//
FwdBwd_Approximate_BFWS::FwdBwd_Approximate_BFWS(std::string domain_file, std::string instance_file)
  : 
    fwd_interface(STRIPS_Interface(domain_file, instance_file)), 
    bwd_interface(STRIPS_Interface_Bwd(domain_file, instance_file)), 
    m_log_filename(LOG_FILE),
    m_plan_filename(PLAN_FILE), m_M(32), m_max_novelty(MAX_NOVELTY),
    m_anytime(false), m_found_plan(false), m_cost(infty), m_cost_bound(infty),
    m_partition_size(0) {}
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

//---- Destructor -----------------------------------------------------------//
FwdBwd_Approximate_BFWS::~FwdBwd_Approximate_BFWS() {}
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

//---------------------------------------------------------------------------//
void FwdBwd_Approximate_BFWS::setup(bool gen_match_tree)
{
  fwd_interface.setup(gen_match_tree);
  bwd_interface.setup(gen_match_tree);
  std::cout << "PDDL problem description loaded: " << std::endl;
  std::cout << "\tDomain: " << fwd_interface.instance()->domain_name() << std::endl;
  std::cout << "\tProblem: " << fwd_interface.instance()->problem_name() << std::endl;
  // std::cout << "\t#Actions: " << fwd_interface.instance()->num_actions() << std::endl;
  // std::cout << "\t#Fluents: " << fwd_interface.instance()->num_fluents() << std::endl;
}
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

//---------------------------------------------------------------------------//
template <typename Search_Engine>
void FwdBwd_Approximate_BFWS::bfws_options(Fwd_Search_Problem &search_prob, Search_Engine &bfs_engine, unsigned max_novelty, Landmarks_Graph &graph)
{

  bfs_engine.set_max_novelty(max_novelty);
  bfs_engine.set_use_novelty(true);
  bfs_engine.rel_fl_h().ignore_rp_h_value(true);

  Land_Graph_Man *lgm = new Land_Graph_Man(search_prob, &graph);
  bfs_engine.use_land_graph_manager(lgm);

  H_Add_Rp_Fwd hadd(search_prob);
  float h_init = 0;
  const aptk::State *s_0 = search_prob.init();
  hadd.eval(*s_0, h_init);
  m_partition_size = graph.num_landmarks() * h_init;

  bfs_engine.set_arity(max_novelty, m_partition_size);
}

template <typename Search_Engine>
void FwdBwd_Approximate_BFWS::bfws_options_bwd( 
  aptk::backward::agnostic::bwd_Search_Problem&	search_prob_bwd, 
  aptk::backward::agnostic::Landmarks_Graph& graph_bwd,
  aptk::backward::agnostic::Fwd_Search_Problem& search_prob_fwd,
  aptk::backward::agnostic::Landmarks_Graph& graph_fwd,
  Search_Engine& bfs_engine, unsigned max_novelty){

    /**
     * check later
     */
	bfs_engine.set_max_novelty_bwd( max_novelty );
	bfs_engine.set_use_novelty_bwd( true );
    bfs_engine.set_max_novelty_fwd( max_novelty );
    bfs_engine.set_use_novelty_fwd( true );
	/** check later
	 *
	 */
	bfs_engine.rel_fl_h().ignore_rp_h_value_bwd(true);
    bfs_engine.rel_fl_h().ignore_rp_h_value_fwd(true);

	//NIR: engine doesn't own the pointer, need to free at the end
	FwdBwd_Approximate_BFWS::Bwd_Land_Graph_Man* lgm 
    = new FwdBwd_Approximate_BFWS::Bwd_Land_Graph_Man( search_prob_bwd, &graph_bwd,
    search_prob_fwd, &graph_fwd);
    /**
     * check later
     */
	bfs_engine.use_land_graph_manager( lgm );
//    bfs_engine.use_land_graph_manager_fwd( lgm );

	//NIR: Approximate the domain of #r counter, so we can initialize the novelty table, making sure we've got
	//     space for novelty > 1 tuples 
	FwdBwd_Approximate_BFWS::Bwd_H_Add_Rp_Fwd hadd( search_prob_bwd,search_prob_fwd);
	float h_init_fwd=0;
    float h_init_bwd=0;
	/** chao edit
	 * change the search_prob.init_state() to search_prob,goal_state()
	 */
	const aptk::backward::State* s_0_fwd = search_prob_fwd.init_state();
    const aptk::backward::State* s_0_bwd = search_prob_bwd.goal_state();
	hadd.eval_fwd( *s_0_fwd, h_init_fwd );
    hadd.eval_bwd( *s_0_bwd, h_init_bwd );
   /** check later
    *
    */

	bfs_engine.set_arity_bwd( max_novelty, graph_bwd.num_landmarks()*h_init_bwd );
    bfs_engine.set_arity_fwd( max_novelty, graph_fwd.num_landmarks()*h_init_fwd );

	
}
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

//---------------------------------------------------------------------------//
template <typename Search_Engine1, typename Search_Engine2>
float FwdBwd_Approximate_BFWS::do_search_iterative_fwd_bwd(
  Search_Engine1 &engine1, Search_Engine2 &engine2, 
  aptk::STRIPS_Problem &plan_prob,
  bool has_arity_2, float prev_time_taken,
  Gen_Lms_FwdBwd* gen_lms
  )
{

  std::ofstream details("execution.details");
  std::vector<aptk::Action_Idx> plan;
  m_cost = infty;
  float				cost_bwd = -1;

  float ref = aptk::time_used();
  float t0 = aptk::time_used();


  unsigned i = 0;
  std::cout << "Num Partitions: " << m_partition_size << std::endl;
  while (!m_found_plan && ++i <= plan_prob.num_fluents())
  {
    std::cout << "Iteration- k=" << i << std::endl;
    {
      engine1.set_max_novelty(i);
      engine1.set_arity(i, m_partition_size);
      if (has_arity_2)
        engine1.set_arity_2(i, 1);

      std::cout << "Clearing Engine..." << std::endl;
      engine1.clear();
      std::cout << "Staring Engine..." << std::endl;
      engine1.start(m_cost_bound);
      std::cout << "Finding Solution..." << std::endl;
      m_found_plan = engine1.find_solution(m_cost, plan);
    }

    if(!m_found_plan && i==1)
    {
      std::cout << "Staring Backward Engine..." << std::endl;
      engine2.start_bwd();
      std::cout << "Finding Solution..." << std::endl;
      m_found_plan = engine2.find_solution_backward(cost_bwd, plan, gen_lms);
      if(!m_found_plan)
      {
        std::cout << "Clearing Backward Engine..." << std::endl;
        // engine2.clear();
      }
    }
  }

  if (m_found_plan)
  {
    std::ofstream plan_stream;
    plan_stream.open(m_plan_filename);
    details << "Plan found with cost: " << m_cost << std::endl;
    for (unsigned k = 0; k < plan.size(); k++)
    {
      details << k + 1 << ". ";
      const auto &a = *(plan_prob.actions()[plan[k]]);
      details << a.signature();
      details << std::endl;
      plan_stream << a.signature() << std::endl;
    }
    float tf = aptk::time_used();
    details << "Time: " << tf - t0 << std::endl;
    t0 = tf;
    plan.clear();
    float total_time = aptk::time_used() - ref;
    std::cout << "Total time: " << total_time << std::endl;
    std::cout << "Plan found with cost: " << m_cost << std::endl;
    std::cout << "Plan found in iteration: " << i << std::endl;
#ifdef __linux__
    aptk::report_memory_usage();
#endif
    details.close();
    plan_stream.close();
    return total_time;
  }
  else
  {
    float tf = aptk::time_used();

    details << "Time: " << tf - t0 + prev_time_taken << std::endl;
    t0 = tf;

    float total_time = aptk::time_used() - ref;
    std::cout << "Total time: " << total_time + prev_time_taken << std::endl;
    std::cout << "Plan found with cost: NOTFOUND" << std::endl;
#ifdef __linux__
    aptk::report_memory_usage();
#endif
    details.close();
    return total_time;
  }
}
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

//---------------------------------------------------------------------------//
void FwdBwd_Approximate_BFWS::solve()
{

  aptk::STRIPS_Problem *prob = fwd_interface.instance();

  Fwd_Search_Problem search_prob(prob);

  prob->compute_edeletes();

  Gen_Lms_Fwd gen_lms(search_prob);
  Landmarks_Graph graph(*prob);

  /**
   * If goal is compiled away into a single dummy goal,
   * then use landmark count instead of goal count
   */
  if (prob->goal().size() != 1)
    gen_lms.set_only_goals(true);
  else
    gen_lms.set_only_goals(false);

  gen_lms.compute_lm_graph_set_additive(graph);

  std::cout << "Goals found: " << graph.num_landmarks() << std::endl;
  std::cout << "Goals_Edges found: " << graph.num_landmarks_and_edges() << std::endl;


  aptk::backward::STRIPS_Problem *prob2 = bwd_interface.instance();

  aptk::backward::agnostic::bwd_Search_Problem	bwd_search_prob( prob2);
	aptk::backward::agnostic::Fwd_Search_Problem  fwd_search_prob (prob2);

  if (!prob2->has_conditional_effects()){
	    auto* h2 =new Bwd_H2_Fwd (bwd_search_prob, fwd_search_prob);
	    h2->compute_edeletes_bwd(*prob2);
	    bwd_search_prob.set_h2_bwd(h2);
	} else
	    prob2->compute_edeletes();

  Gen_Lms_FwdBwd    gen_lms_fwdbwd( bwd_search_prob, fwd_search_prob);
  aptk::backward::agnostic::Landmarks_Graph graph_bwd( *prob2 );
  aptk::backward::agnostic::Landmarks_Graph graph_fwd( *prob2 );
	gen_lms_fwdbwd.set_only_goals_fwd(true );
	gen_lms_fwdbwd.set_goal_ordering_fwd(true );
  gen_lms_fwdbwd.set_only_goals_bwd(true );
  gen_lms_fwdbwd.set_goal_ordering_bwd(true );

  /**
   * check the compute_lm_graph_set_additive_forward_fwd suitable for graph_bwd and the same for backward
   */
  gen_lms_fwdbwd.compute_lm_graph_set_additive_fwd(graph_fwd);
	gen_lms_fwdbwd.compute_lm_graph_set_additive_bwd( graph_bwd );

  m_found_plan = false;
  m_cost = infty;
  std::cout << m_search_alg << std::endl;

  // if (m_search_alg.compare("k-BFWS-landmarks-Iter") == 0)
  // {

  //   std::cout << "Starting search with k-BFWS-landmarks-Iter..." << std::endl;

  //   k_BFWS bfs_engine(search_prob, m_sample_factor, m_sampling_strategy,
  //             m_rand_seed, m_min_k4sample, m_verbose, m_sample_fs,
  //             m_bf_fs_gb, m_bf_max_size_gb);

  //   /**
  //    * Use landmark count instead of goal count
  //    */
  //   Gen_Lms_Fwd gen_lms(search_prob);
  //   gen_lms.set_only_goals(false);
  //   Landmarks_Graph graph1(*prob);
  //   gen_lms.compute_lm_graph_set_additive(graph1);

  //   bfws_options(search_prob, bfs_engine, 1, graph1);
  //   bfs_engine.set_use_novelty_pruning(true);

  //   float bfs_t = do_search_iterative(bfs_engine, *prob, plan_stream, false);

  //   std::cout << "Fast-BFS search completed in " << bfs_t << " secs" << std::endl;

  //   plan_stream.close();

  //   return;
  // }
  // else if (m_search_alg.compare("k-BFWS-landmarks-Iter-OLC") == 0)
  // {

  //   std::cout << "Starting search with k-BFWS-landmarks-Iter..." << std::endl;

  //   k_BFWS bfs_engine(search_prob, m_sample_factor, m_sampling_strategy,
  //             m_rand_seed, m_min_k4sample, m_verbose, m_sample_fs,
  //             m_bf_fs_gb, m_bf_max_size_gb);

  //   /**
  //    * Use landmark count instead of goal count
  //    */
  //   Gen_Lms_Fwd gen_lms(search_prob);
  //   gen_lms.set_only_goals(false);
  //   Landmarks_Graph graph1(*prob);
  //   gen_lms.compute_lm_graph_set_additive(graph1);

  //   bfws_options(search_prob, bfs_engine, 1, graph1);
  //   bfs_engine.set_use_novelty_pruning(true);
  //   bfs_engine.set_use_random_pruning(true, m_alpha_rand_prune,
  //                     m_enable_hold_q, m_rand_prune_slack);

  //   float bfs_t = do_search_iterative(bfs_engine, *prob, plan_stream, false);

  //   std::cout << "Fast-BFS search completed in " << bfs_t << " secs" << std::endl;

  //   plan_stream.close();

  //   return;
  // }
  // else if (m_search_alg.compare("k-BFWS-Iter") == 0)
  // {

  //   std::cout << "Starting search with k-BFWS iterative..." << std::endl;

  //   k_BFWS bfs_engine(search_prob, m_sample_factor, m_sampling_strategy,
  //             m_rand_seed, m_min_k4sample, m_verbose, m_sample_fs,
  //             m_bf_fs_gb, m_bf_max_size_gb);

  //   bfws_options(search_prob, bfs_engine, 1, graph);

  //   bfs_engine.set_use_novelty_pruning(true);

  //   float bfs_t = do_search_iterative(bfs_engine, *prob, plan_stream, false);

  //   std::cout << "k-BFWS iterative search completed in " << bfs_t << " secs" << std::endl;

  //   plan_stream.close();

  //   return;
  // }
  // else 
  if (m_search_alg.compare("k-BFWS-Iter-OLC") == 0)
  {

    std::cout << "Starting search with k-BFWS iterative..." << std::endl;

    k_BFWS bfs_engine(search_prob, m_sample_factor, m_sampling_strategy,
              m_rand_seed, m_min_k4sample, m_verbose, m_sample_fs,
              m_bf_fs_gb, m_bf_max_size_gb);

    bfws_options(search_prob, bfs_engine, 1, graph);

    bfs_engine.set_use_novelty_pruning(true);
    bfs_engine.set_use_random_pruning(true, m_alpha_rand_prune,
                      m_enable_hold_q, m_rand_prune_slack);


    // Backward Engine

    k_FFWS bfs_engine2(bwd_search_prob, fwd_search_prob);
    unsigned w = 1;
    bfws_options_bwd( bwd_search_prob ,graph_bwd, 
      fwd_search_prob, graph_fwd, bfs_engine2, w);

    bfs_engine2.set_use_novelty_pruning_bwd(true);

    float bfs_t = do_search_iterative_fwd_bwd(
      bfs_engine, bfs_engine2, *prob, false, 0.0, &gen_lms_fwdbwd);

    std::cout << "k-BFWS forward backward iterative search completed in " << bfs_t << " secs" << std::endl;

    return;
  }
  // else if (m_search_alg.compare("DUAL-BFWS-Iter") == 0)
  // {
  //   std::cout << "Starting search with 1-BFWS..." << std::endl;

  //   k_BFWS bfs_engine(search_prob, m_sample_factor,
  //             m_sampling_strategy, m_rand_seed, m_min_k4sample, m_verbose, m_sample_fs,
  //             m_bf_fs_gb, m_bf_max_size_gb);

  //   bfws_options(search_prob, bfs_engine, 1, graph);

  //   bfs_engine.set_use_novelty_pruning(true);

  //   float bfs_t = do_search(bfs_engine, *prob, plan_stream, false);

  //   std::cout << "Fast-BFS search completed in " << bfs_t << " secs" << std::endl;

  //   if (!m_found_plan)
  //   {
  //     std::cout << "Starting search with BFWS(novel,land,h_ff)..." << std::endl;

  //     BFWS_w_hlm_hadd bfs_engine(search_prob,
  //                    m_sample_factor, m_sampling_strategy,
  //                    m_rand_seed, m_min_k4sample, m_verbose);
  //     bfs_engine.h4().ignore_rp_h_value(true);

  //     /**
  //      * Use landmark count instead of goal count
  //      */
  //     Gen_Lms_Fwd gen_lms(search_prob);
  //     gen_lms.set_only_goals(false);
  //     Landmarks_Graph graph1(*prob);
  //     gen_lms.compute_lm_graph_set_additive(graph1);

  //     Land_Graph_Man lgm(search_prob, &graph1);
  //     bfs_engine.use_land_graph_manager(&lgm);

  //     std::cout << "Landmarks found: " << graph1.num_landmarks() << std::endl;
  //     std::cout << "Landmarks_Edges found: " << graph1.num_landmarks_and_edges() << std::endl;
  //     m_partition_size = graph1.num_landmarks_and_edges();

  //     // bfs_engine.set_arity( m_max_novelty, graph1.num_landmarks_and_edges() );
  //     // bfs_engine.set_arity_2( m_max_novelty,  1 );

  //     m_found_plan = false;
  //     bfs_engine.set_use_novelty_pruning(true);
  //     bfs_t = do_search_iterative(bfs_engine, *prob, plan_stream, true, bfs_t);

  //     std::cout << "DUAL BFWS search completed in " << bfs_t << " secs" << std::endl;
  //   }
  // }

  // if (m_anytime and (m_cost < infty))
  // {
  //   std::cout << "Stage #3: RWA* " << std::endl;
  //   Anytime_RWA wbfs_engine(search_prob, 10.0f, 0.95f);

  //   /**
  //    * Use landmark count instead of goal count
  //    */
  //   Gen_Lms_Fwd gen_lms(search_prob);
  //   gen_lms.set_only_goals(false);
  //   Landmarks_Graph graph1(*prob);
  //   gen_lms.compute_lm_graph_set_additive(graph1);

  //   Land_Graph_Man lgm(search_prob, &graph1);
  //   wbfs_engine.use_land_graph_manager(&lgm);

  //   m_cost_bound = m_cost;

  //   float at_search_t = do_anytime(wbfs_engine);

  //   std::cout << "\nRWA search completed in " << at_search_t << " secs, found plan cost = " << m_cost << std::endl;
  // }
}
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
