

#include <fwdbwd_approximate_bfws.hxx>


#include <py_strips_interface.hxx>
// #include <tarski_instantiator.hxx>
// #include <strips_prob.hxx>

namespace py = pybind11;

// using namespace tarski;

PYBIND11_MODULE(planner, m)
{
  py::module_::import("lapkt.core.lib.wrapper");

  py::class_<FwdBwd_Approximate_BFWS>(m, "FwdBwd_Approximate_BFWS")
    .def(py::init<>())
    .def( "setup", &FwdBwd_Approximate_BFWS::setup )
    .def( "solve", &FwdBwd_Approximate_BFWS::solve )
    // .def_readwrite( "parsing_time", &FwdBwd_Approximate_BFWS::m_parsing_time )
    .def( "set_ignore_action_costs", &FwdBwd_Approximate_BFWS::set_ignore_action_costs)
    .def_readwrite( "fwd_interface", &FwdBwd_Approximate_BFWS::fwd_interface )
    .def_readwrite( "bwd_interface", &FwdBwd_Approximate_BFWS::bwd_interface )
    .def_readwrite( "anytime", &FwdBwd_Approximate_BFWS::m_anytime )
    .def_readwrite( "log_filename", &FwdBwd_Approximate_BFWS::m_log_filename )
    .def_readwrite( "search", &FwdBwd_Approximate_BFWS::m_search_alg )
    .def_readwrite( "m_value", &FwdBwd_Approximate_BFWS::m_M )
    .def_readwrite( "max_novelty", &FwdBwd_Approximate_BFWS::m_max_novelty )
    .def_readwrite( "plan_filename", &FwdBwd_Approximate_BFWS::m_plan_filename )
    .def_readwrite( "found_plan", &FwdBwd_Approximate_BFWS::m_found_plan )
    .def_readwrite( "plan_cost", &FwdBwd_Approximate_BFWS::m_cost )
    .def_readwrite( "cost_bound", &FwdBwd_Approximate_BFWS::m_cost_bound )
    .def_readwrite( "bf_fs", &FwdBwd_Approximate_BFWS::m_bf_fs_gb )
    .def_readwrite( "bf_max_size", &FwdBwd_Approximate_BFWS::m_bf_max_size_gb )
    .def_readwrite( "sample_fs", &FwdBwd_Approximate_BFWS::m_sample_fs )
    .def_readwrite( "sample_factor", &FwdBwd_Approximate_BFWS::m_sample_factor )
    .def_readwrite( "sampling_strategy", &FwdBwd_Approximate_BFWS::m_sampling_strategy )
    .def_readwrite( "rand_seed", &FwdBwd_Approximate_BFWS::m_rand_seed )
    .def_readwrite( "min_k4sample", &FwdBwd_Approximate_BFWS::m_min_k4sample )
    .def_readwrite( "alpha_rand_prune", &FwdBwd_Approximate_BFWS::m_alpha_rand_prune )
    .def_readwrite( "slack", &FwdBwd_Approximate_BFWS::m_rand_prune_slack )
    .def_readwrite( "use_hq", &FwdBwd_Approximate_BFWS::m_enable_hold_q )
    .def_readwrite( "verbose", &FwdBwd_Approximate_BFWS::m_verbose )
    ;
}