/**
 * @file fwdbwd_approximate_bfws.hxx
 * @author Anubhav Singh (anubhav.singh.er@pm.me)
 * @author Miquel Ramirez (miquel.ramirez@unimelb.edu.au)
 * @author Nir Lipovetzky (nirlipo@gmail.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-28
 * 
 * @copyright Copyright (c) 2023
 * 
  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files
  (the "Software"), to deal in the Software without restriction,
  including without limitation the rights to use, copy, modify, merge,
  publish, distribute, sublicense, and/or sell copies of the Software,
  and to permit persons to whom the Software is furnished to do so, subject
  to the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#ifndef __FwdBwd1_Approximate_BFWS__
#define __FwdBwd1_Approximate_BFWS__

//---- CONSTANTS
#define MAX_NOVELTY 2
#define LOG_FILE "planner.log"
#define PLAN_FILE "plan.ipc"

/**
 * LAPKT includes
 */
#include <py_strips_interface.hxx>
#include <py_strips_interface_bwd.hxx>

#include <iostream>
#include <fstream>

#include <fluent.hxx>
#include <action.hxx>
#include <cond_eff.hxx>
#include <strips_state.hxx>
#include <fwd_search_prob.hxx>
#include <landmark_graph.hxx>
#include <landmark_graph_generator.hxx>
#include <landmark_graph_manager.hxx>
#include "landmark_count.hxx"
#include <h_2.hxx>
#include <h_1.hxx>
#include <layered_h_max.hxx>

#include <bwd_fluent.hxx>
#include <bwd_action.hxx>
#include <bwd_cond_eff.hxx>
#include <bwd_strips_state.hxx>
#include <bwd_fwd_search_prob.hxx>
#include <bwd_landmark_graph.hxx>
#include <bwd_landmark_graph_generator.hxx>
#include <bwd_landmark_graph_manager.hxx>
#include "bwd_landmark_count.hxx"
#include <bwd_h_2.hxx>
#include <bwd_h_1.hxx>
#include <bwd_layered_h_max.hxx>
#include <bwd_novelty_partition.hxx>

#include <open_list.hxx>
#include <bwd_open_list.hxx>
#include <string_conversions.hxx>

#include <boost/program_options.hpp>

/**
 * Local includes
 */

#include "approximate_novelty_partition_1.hxx"
#include "approximate_novelty_partition_2.hxx"
#include "ff_rp_heuristic.hxx"
#include "rp_heuristic.hxx"
#include "rp_heuristic_bfws.hxx"

#include "approx_novelty_bfws_4h.hxx"
#include "approx_novelty_bfws_2h.hxx"
#include "approx_novelty_bfws_2h_M.hxx"
#include "approx_novelty_bfws_2h_consistency.hxx"
#include "approx_novelty_bfws_2h_consistency_M.hxx"

#include "bfws_forward_backward.hxx"

#include "ipc2014_rwa.hxx"

#include "new_node_comparer.hxx"

namespace po = boost::program_options;

/**
 * NAMESPACES
 */

using aptk::Action;
using aptk::agnostic::Fwd_Search_Problem;
using aptk::agnostic::Landmarks_Count_Heuristic;
using aptk::agnostic::Landmarks_Graph;
using aptk::agnostic::Landmarks_Graph_Generator;
using aptk::agnostic::Landmarks_Graph_Manager;

using aptk::agnostic::H1_Cost_Function;
using aptk::agnostic::H1_Heuristic;
using aptk::agnostic::H2_Heuristic;
using aptk::agnostic::Layered_H_Max;
using aptk::agnostic::RP_Cost_Function;

using aptk::agnostic::FF_Relaxed_Plan_Heuristic;
using aptk::agnostic::H_Add_Evaluation_Function;
using aptk::agnostic::H_Max_Evaluation_Function;
using aptk::agnostic::Relaxed_Plan_Heuristic;

using aptk::agnostic::Approximate_Novelty_Partition;
using aptk::agnostic::Approximate_Novelty_Partition_2;

using aptk::search::Node_Comparer_2H;
using aptk::search::Node_Comparer_2H_gn_unit;
using aptk::search::Node_Comparer_4H;
using aptk::search::Open_List;

using aptk::search::backward::BFWS_Forward_Backward;

using namespace aptk::search;
using aptk::search::bfs_dq_mh::IPC2014_RWA;

class FwdBwd_Approximate_BFWS
{
  /**
   * DEFINITIONS
   */

  typedef H2_Heuristic<Fwd_Search_Problem> H2_Fwd;
  typedef Landmarks_Graph_Generator<Fwd_Search_Problem> Gen_Lms_Fwd;
  typedef Landmarks_Count_Heuristic<Fwd_Search_Problem> H_Lmcount_Fwd;
  typedef Landmarks_Graph_Manager<Fwd_Search_Problem> Land_Graph_Man;


  typedef approximate_bfws_4h::Node<Fwd_Search_Problem, aptk::State> Search_Node_4h;
  typedef approximate_bfws_2h::Node<Fwd_Search_Problem, aptk::State> Search_Node_2h;
  typedef ipc2014::Node<aptk::State> AT_Search_Node;

  typedef Approximate_Novelty_Partition<Fwd_Search_Problem, Search_Node_4h> H_Novel_Fwd_4h;
  typedef Approximate_Novelty_Partition_2<Fwd_Search_Problem, Search_Node_4h> H_Novel_2_Fwd_4h;

  typedef Approximate_Novelty_Partition<Fwd_Search_Problem, Search_Node_2h> H_Novel_Fwd_2h;

  typedef Node_Comparer_4H<Search_Node_4h> Tie_Breaking_Algorithm_4h;
  typedef Node_Comparer_2H_gn_unit<Search_Node_2h> Tie_Breaking_Algorithm_2h_ignore_costs;

  typedef Open_List<Tie_Breaking_Algorithm_4h, Search_Node_4h> BFS_Open_List_4h;
  typedef Open_List<Tie_Breaking_Algorithm_2h_ignore_costs, Search_Node_2h> BFS_Open_List_2h;
  typedef AT_Search_Node::Open_List AT_BFS_Open_List;

  typedef H1_Heuristic<Fwd_Search_Problem, H_Add_Evaluation_Function, H1_Cost_Function::Ignore_Costs> H_Add_Fwd;
  typedef Relaxed_Plan_Heuristic<Fwd_Search_Problem, H_Add_Fwd, RP_Cost_Function::Ignore_Costs> H_Add_Rp_Fwd;

  typedef H1_Heuristic<Fwd_Search_Problem, H_Add_Evaluation_Function, H1_Cost_Function::Use_Costs> H_Add_Fwd_use_costs;
  typedef Relaxed_Plan_Heuristic<Fwd_Search_Problem, H_Add_Fwd, RP_Cost_Function::Use_Costs> H_Add_Rp_Fwd_use_costs;

  typedef Layered_H_Max<Fwd_Search_Problem> Alt_H_Max;
  typedef FF_Relaxed_Plan_Heuristic<Fwd_Search_Problem, Alt_H_Max, unsigned> Classic_FF_H_Max;

  typedef approximate_bfws_2h::BFWS_2H<Fwd_Search_Problem, H_Novel_Fwd_2h, H_Lmcount_Fwd, H_Add_Rp_Fwd, BFS_Open_List_2h> k_BFWS;
  typedef approximate_bfws_2h::BFWS_2H_M<Fwd_Search_Problem, H_Novel_Fwd_2h, H_Lmcount_Fwd, H_Add_Rp_Fwd, BFS_Open_List_2h> k_BFWS_M;
  typedef approximate_bfws_4h::BFWS_4H<Fwd_Search_Problem, H_Novel_Fwd_4h, H_Lmcount_Fwd, H_Novel_2_Fwd_4h, H_Add_Rp_Fwd, BFS_Open_List_4h> BFWS_w_hlm_hadd;

  typedef approximate_bfws_2h::BFWS_2H_Consistency<Fwd_Search_Problem, H_Novel_Fwd_2h, H_Lmcount_Fwd, H_Add_Rp_Fwd, BFS_Open_List_2h> k_BFWS_Consistency;
  typedef approximate_bfws_2h::BFWS_2H_Consistency_M<Fwd_Search_Problem, H_Novel_Fwd_2h, H_Lmcount_Fwd, H_Add_Rp_Fwd, BFS_Open_List_2h> k_BFWS_Consistency_M;

  typedef IPC2014_RWA<Fwd_Search_Problem, H_Add_Rp_Fwd_use_costs, H_Lmcount_Fwd, AT_BFS_Open_List> Anytime_RWA;

  typedef         aptk::backward::agnostic::H2_Heuristic<
    aptk::backward::agnostic::bwd_Search_Problem, 
    aptk::backward::agnostic::Fwd_Search_Problem>                  Bwd_H2_Fwd;

  typedef         aptk::backward::agnostic::Landmarks_Graph_Manager<
    aptk::backward::agnostic::bwd_Search_Problem,
    aptk::backward::agnostic::Fwd_Search_Problem>       Bwd_Land_Graph_Man;

  typedef   aptk::backward::agnostic::Landmarks_Graph_Generator<
    aptk::backward::agnostic::bwd_Search_Problem, 
    aptk::backward::agnostic::Fwd_Search_Problem> Gen_Lms_FwdBwd;

  typedef   aptk::backward::agnostic::Landmarks_Count_Heuristic<
    aptk::backward::agnostic::bwd_Search_Problem,
    aptk::backward::agnostic::Fwd_Search_Problem> Bwd_H_Lmcount_Fwd;

  typedef		aptk::backward::agnostic::H1_Heuristic<
    aptk::backward::agnostic::bwd_Search_Problem, 
    aptk::backward::agnostic::Fwd_Search_Problem, 
    aptk::backward::agnostic::H_Add_Evaluation_Function>	Bwd_H_Add_Fwd;

  typedef		aptk::backward::agnostic::Relaxed_Plan_Heuristic< 
    aptk::backward::agnostic::bwd_Search_Problem, 
    aptk::backward::agnostic::Fwd_Search_Problem, Bwd_H_Add_Fwd >	Bwd_H_Add_Rp_Fwd;

  typedef		aptk::search::backward::Node< 
    aptk::backward::agnostic::bwd_Search_Problem,
    aptk::backward::agnostic::Fwd_Search_Problem, 
    aptk::backward::State >	Search_Node_2h_Forward_Backward;

  typedef    aptk::backward::agnostic::Novelty_Partition<
    aptk::backward::agnostic::bwd_Search_Problem, 
    aptk::backward::agnostic::Fwd_Search_Problem,
    Search_Node_2h_Forward_Backward>  H_Novel_Fwd_2h_Forward_backward;

  typedef		Node_Comparer_2H< 
    Search_Node_2h_Forward_Backward >	 Tie_Breaking_Algorithm_2h_Forward_Backward;
  typedef		aptk::search::backward::Open_List< 
    Tie_Breaking_Algorithm_2h_Forward_Backward , Search_Node_2h_Forward_Backward >	 BFS_Open_List_2h_Forward_Backward;

  typedef	BFWS_Forward_Backward< 
  aptk::backward::agnostic::bwd_Search_Problem, 
  aptk::backward::agnostic::Fwd_Search_Problem, 
  H_Novel_Fwd_2h_Forward_backward , 
  Bwd_H_Lmcount_Fwd, 
  Bwd_H_Add_Rp_Fwd, 
  BFS_Open_List_2h_Forward_Backward
  >                       k_FFWS;


public:
  FwdBwd_Approximate_BFWS();
  FwdBwd_Approximate_BFWS(std::string, std::string);
  virtual ~FwdBwd_Approximate_BFWS();

  virtual void setup(bool gen_match_tree = true);
  void solve();

  void set_ignore_action_costs(bool value) {
   fwd_interface.m_ignore_action_costs = value;
   bwd_interface.m_ignore_action_costs = value;
  }

  std::string m_log_filename;
  std::string m_plan_filename;
  std::string m_search_alg;
  unsigned m_M;
  unsigned m_max_novelty;
  bool m_anytime;
  bool m_found_plan;
  float m_cost;
  float m_cost_bound;
  float m_sample_factor;
  std::string m_sampling_strategy;
  unsigned m_partition_size;
  unsigned m_rand_seed;
  unsigned m_min_k4sample;
  float m_bf_fs_gb;
  float m_bf_max_size_gb;
  unsigned m_sample_fs;
  float m_alpha_rand_prune;
  bool m_enable_hold_q;
  int m_rand_prune_slack;
  bool m_verbose;

  STRIPS_Interface fwd_interface;
  STRIPS_Interface_Bwd bwd_interface;

protected:
  template <typename Search_Engine>
  void bfws_options(Fwd_Search_Problem &search_prob,
            Search_Engine &bfs_engine, unsigned max_novelty,
            Landmarks_Graph &graph);

  template <typename Search_Engine>
  void bfws_options_bwd( 
    aptk::backward::agnostic::bwd_Search_Problem&	search_prob_bwd, 
    aptk::backward::agnostic::Landmarks_Graph& graph_bwd,
    aptk::backward::agnostic::Fwd_Search_Problem& search_prob_fwd,
    aptk::backward::agnostic::Landmarks_Graph& graph_fwd,
    Search_Engine& bfs_engine, unsigned max_novelty
    );

  template <typename Search_Engine1, typename Search_Engine2>
  float do_search_iterative_fwd_bwd(
    Search_Engine1 &engine1, Search_Engine2 &engine2, aptk::STRIPS_Problem &plan_prob,
    bool has_arity_2 = true, float prev_time_taken = 0.0,
    Gen_Lms_FwdBwd* gen_lms = NULL
    );

};

#endif
