#include <py_strips_interface_bwd.hxx>
#include <cstring>
#include <fstream>
#include <iostream>

STRIPS_Interface_Bwd::STRIPS_Interface_Bwd()
{
	m_parsing_time = 0.0f;
	m_ignore_action_costs = false;
	m_problem = new aptk::backward::STRIPS_Problem;
}
STRIPS_Interface_Bwd::STRIPS_Interface_Bwd(std::string domain, std::string instance)
{
	m_parsing_time = 0.0f;
	m_ignore_action_costs = false;
	m_problem = new aptk::backward::STRIPS_Problem(domain, instance);
}

STRIPS_Interface_Bwd::~STRIPS_Interface_Bwd() {}

void STRIPS_Interface_Bwd::add_atom(std::string name)
{
	assert(m_negated.empty());
	aptk::backward::STRIPS_Problem::add_fluent(*instance(), name);
}

void STRIPS_Interface_Bwd::add_action(std::string name, bool flag_tarski)
{
	aptk::backward::Fluent_Vec empty;
	aptk::backward::Conditional_Effect_Vec dummy_ceffs;
	aptk::backward::STRIPS_Problem::add_action(*instance(),
																	 name, empty, empty, empty, dummy_ceffs, 1.0f);
}

// Anu - Updated for Tarski CPP integration
void STRIPS_Interface_Bwd::notify_negated_atom(unsigned &fl_idx)
{
	assert(fl_idx < instance()->num_fluents());
	if (m_negated_conditions.find(fl_idx) == m_negated_conditions.end())
	{
		m_negated_conditions.insert(fl_idx);
		aptk::backward::Fluent *fl = instance()->fluents()[fl_idx];
		assert(fl != nullptr);
		std::string negated_signature = "(not " + fl->signature() + ")";
		unsigned neg_fl_idx = aptk::backward::STRIPS_Problem::add_fluent(
				*instance(), negated_signature);
		m_negated.at(fl_idx) = instance()->fluents()[neg_fl_idx];
	}
}

void STRIPS_Interface_Bwd::notify_negated_conditions(py::list &fluents)
{
	for (int i = 0; i < py::len(fluents); i++)
	{
		unsigned fl_index = fluents[i].cast<unsigned>();
		assert(fl_index < instance()->num_fluents());
		m_negated_conditions.insert(fl_index);
	}
}

void STRIPS_Interface_Bwd::create_negated_fluents()
{
	m_negated.resize(instance()->num_fluents());
	unsigned count = 0;
	for (auto fl_idx : m_negated_conditions)
	{
		aptk::backward::Fluent *fl = instance()->fluents()[fl_idx];
		assert(fl != nullptr);
		std::string negated_signature = "(not " + fl->signature() + ")";
		unsigned neg_fl_idx = aptk::backward::STRIPS_Problem::add_fluent(*instance(), negated_signature);
		m_negated.at(fl_idx) = instance()->fluents()[neg_fl_idx];
		count++;
	}
	std::cout << count << " negated fluents created" << std::endl;
}

// Anu - For Tarski CPP integration
void STRIPS_Interface_Bwd::set_size_negated_fluents(size_t size)
{
	m_negated.resize(size, nullptr);
}
// For Py interface
void STRIPS_Interface_Bwd::add_precondition(int index, py::list &lits)
{
	aptk::backward::Action &action = *(m_problem->actions()[index]);
	for (int i = 0; i < py::len(lits); i++)
	{
		py::tuple li = lits[i];
		int fl_idx = li[0].cast<int>();
		bool negated = li[1].cast<bool>();

		if (negated)
			fl_idx = m_negated[fl_idx]->index();
		action.prec_vec().push_back(fl_idx);
		action.prec_set().set(fl_idx);
		action.prec_varval().push_back(std::make_pair(fl_idx, 0));
	}
}

// For Tarski CPP
void STRIPS_Interface_Bwd::add_precondition(int index,
																				std::vector<std::pair<int, bool>> &lits)
{
	aptk::backward::Action &action = *(m_problem->actions()[index]);
	for (size_t i = 0; i < lits.size(); i++)
	{
		int fl_idx = lits[i].first;
		bool negated = lits[i].second;

		if (negated)
			fl_idx = m_negated[fl_idx]->index();

		action.prec_vec().push_back(fl_idx);
		// action.prec_set().set(fl_idx);
		action.prec_varval().push_back(std::make_pair(fl_idx, 0));
	}
}

void STRIPS_Interface_Bwd::add_cond_effect(int index, py::list &cond_lits,
																			 py::list &eff_lits)
{
	aptk::backward::Action &action = *(m_problem->actions()[index]);
	aptk::backward::Fluent_Vec cond_fluents;
	aptk::backward::Fluent_Vec add_fluents;
	aptk::backward::Fluent_Vec del_fluents;
	for (int i = 0; i < py::len(cond_lits); i++)
	{
		py::tuple li = cond_lits[i];
		int fl_idx = li[0].cast<int>();
		bool negated = li[1].cast<bool>();
		if (negated)
			fl_idx = m_negated[fl_idx]->index();

		cond_fluents.push_back(fl_idx);
	}

	for (int i = 0; i < py::len(eff_lits); i++)
	{
		py::tuple li = eff_lits[i];

		int fl_idx = li[0].cast<int>();
		bool negated = li[1].cast<bool>();

		if (m_negated[fl_idx] == nullptr)
		{
			if (negated)
			{
				del_fluents.push_back(fl_idx);
			}
			else
			{
				add_fluents.push_back(fl_idx);
			}
			continue;
		}
		int neg_fl_idx = m_negated[fl_idx]->index();
		if (negated)
		{
			add_fluents.push_back(neg_fl_idx);
			del_fluents.push_back(fl_idx);
			continue;
		}
		del_fluents.push_back(neg_fl_idx);
		add_fluents.push_back(fl_idx);
	}
	aptk::backward::Conditional_Effect *cond_eff =
			new aptk::backward::Conditional_Effect(*instance());
	cond_eff->define(cond_fluents, add_fluents, del_fluents);
	action.ceff_vec().push_back(cond_eff);
	m_problem->notify_cond_eff_in_action();
}

void STRIPS_Interface_Bwd::add_effect(int index, py::list &lits)
{
	aptk::backward::Action &action = *(m_problem->actions()[index]);
	for (int i = 0; i < py::len(lits); i++)
	{
		py::tuple li = lits[i];
		int fl_idx = li[0].cast<int>();
		bool negated = li[1].cast<bool>();
		if (m_negated[fl_idx] == nullptr)
		{
			if (negated)
			{
				action.del_vec().push_back(fl_idx);
				action.del_set().set(fl_idx);
				action.edel_vec().push_back(fl_idx);
				action.edel_set().set(fl_idx);
			}
			else
			{
				action.add_vec().push_back(fl_idx);
				action.add_set().set(fl_idx);
			}
			continue;
		}
		int neg_fl_idx = m_negated[fl_idx]->index();
		if (negated)
		{
			action.add_vec().push_back(neg_fl_idx);
			action.add_set().set(neg_fl_idx);
			action.del_vec().push_back(fl_idx);
			action.del_set().set(fl_idx);
			action.edel_vec().push_back(fl_idx);
			action.edel_set().set(fl_idx);
			continue;
		}
		action.del_vec().push_back(neg_fl_idx);
		action.del_set().set(neg_fl_idx);
		action.edel_vec().push_back(neg_fl_idx);
		action.edel_set().set(neg_fl_idx);
		action.add_vec().push_back(fl_idx);
		action.add_set().set(fl_idx);
	}
}

void STRIPS_Interface_Bwd::add_mutex_group(py::list &lits)
{
	aptk::backward::Fluent_Vec group;
	for (int i = 0; i < py::len(lits); i++)
	{
		py::tuple li = (lits[i]);
		int fl_idx = li[0].cast<int>();
		bool negated = li[1].cast<bool>();
		if (negated)
			fl_idx = m_negated[fl_idx]->index();
		group.push_back(fl_idx);
	}
	m_problem->mutexes().add(group);
}

void STRIPS_Interface_Bwd::set_cost(int index, float c)
{
	aptk::backward::Action &action = *(m_problem->actions()[index]);
	if (m_ignore_action_costs)
	{
		action.set_cost(1.0f);
		return;
	}
	const float min_action_cost = 1e-3;
	if (c < min_action_cost)
		c = min_action_cost;
	action.set_cost(c);
}

void STRIPS_Interface_Bwd::set_init(py::list &lits)
{
	aptk::backward::Fluent_Vec I;
	for (int i = 0; i < py::len(lits); i++)
	{
		py::tuple li = (lits[i]);
		int fl_idx = li[0].cast<int>();
		bool negated = li[1].cast<bool>();
		if (negated)
		{
			assert(m_negated[fl_idx]);
			I.push_back(m_negated[fl_idx]->index());
			continue;
		}
		I.push_back(fl_idx);
	}
	// complete initial state under negation
	for (unsigned p = 0; p < instance()->num_fluents(); p++)
	{
		if (p >= m_negated.size())
			continue; // p is a negated fluent!
		if (std::find(I.begin(), I.end(), p) != I.end())
			continue;
		assert(p < m_negated.size());
		if (m_negated.at(p))
			I.push_back(m_negated[p]->index());
	}
	aptk::backward::STRIPS_Problem::set_init(*instance(), I);
}

void STRIPS_Interface_Bwd::set_goal(py::list &lits)
{
	aptk::backward::Fluent_Vec G;

	for (int i = 0; i < py::len(lits); i++)
	{
		py::tuple li = (lits[i]);
		int fl_idx = li[0].cast<int>();
		bool negated = li[1].cast<bool>();
		if (negated)
		{
			assert(m_negated[fl_idx]);
			G.push_back(m_negated[fl_idx]->index());
			continue;
		}
		G.push_back(fl_idx);
	}
	aptk::backward::STRIPS_Problem::set_goal(*instance(), G);
}

void STRIPS_Interface_Bwd::set_domain_name(std::string name)
{
	instance()->set_domain_name(name);
}

void STRIPS_Interface_Bwd::set_problem_name(std::string name)
{
	instance()->set_problem_name(name);
}

void STRIPS_Interface_Bwd::print_action(int index)
{
	instance()->actions()[index]->print(*instance(), std::cout);
}

void STRIPS_Interface_Bwd::write_ground_pddl(std::string domain, std::string problem)
{
	/*
	std::ofstream domain_stream(domain.c_str());
	m_inst->write_domain(domain_stream);
	std::ofstream problem_stream(problem.c_str());
	m_inst->write_problem(problem_stream);
	*/
}

void STRIPS_Interface_Bwd::setup(bool gen_match_table)
{
	instance()->make_action_tables(gen_match_table);
	instance()->make_effect_tables();
}

void STRIPS_Interface_Bwd::print_fluents()
{
	std::ofstream out("fluents.list");
	instance()->print_fluents(out);
	out.close();
}

void STRIPS_Interface_Bwd::print_actions()
{
	std::ofstream out("actions.list");
	instance()->print_actions(out);
	out.close();
}
