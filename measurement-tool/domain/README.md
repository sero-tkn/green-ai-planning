<a id="readme-top"></a>

# Domain Directory

This directory contains the PDDL domain files used in conjunction with the Energy Measurement Framework for Classical
Planners.

## Domain Model Modifications

This file documents all domain model modifications used in this project.
The modifications are grouped into three categories:

- **Syntactic Variants** (`SV-XXX`)
- **Modeling Inefficiencies** (`MI-XXX`)
- **Solvability Constraints** (`SC-XXX`)

The original, unmodified domain models are referred to as `ORG`.

## Syntactic Variants (`SV-XXX`)

These modifications alter the **order of elements** within PDDL domain files while preserving semantics.

| Domain    | Description                                                              |
|-----------|--------------------------------------------------------------------------|
| SV-PDU1/2 | Reorder predicate declarations by usage frequency (descending/ascending) |
| SV-PDA1/2 | Reorder predicate declarations alphabetically (descending/ascending)     |
| SV-OEF1/2 | Sort operators by number of effect literals (descending/ascending)       |
| SV-ONE1/2 | Sort operators by number of negative effects (descending/ascending)      |
| SV-OPR1/2 | Sort operators by number of preconditions (descending/ascending)         |
| SV-OPA1/2 | Sort operators by number of parameters (descending/ascending)            |
| SV-ORA1/2 | Sort operators by effect/precondition ratio (descending/ascending)       |
| SV-OAN1/2 | Sort operators alphabetically by name (descending/ascending)             |
| SV-PRR    | Reverse the order of preconditions                                       |
| SV-PRA1/2 | Sort preconditions alphabetically (descending/ascending)                 |
| SV-EFR    | Reverse the order of effect literals                                     |
| SV-EFA1/2 | Sort effect literals alphabetically (descending/ascending)               |

**Total: 22 variants**

## Modeling Inefficiencies (`MI-XXX`)

These modifications introduce **redundant** into the domain or problem files without altering solvability.

| Domain  | Description                                                         |
|---------|---------------------------------------------------------------------|
| MI-ROB  | Add inert dummy objects to the problem file                         |
| MI-RPD  | Add unused dummy predicates to the domain file                      |
| MI-RPA  | Increase predicate arity by adding dummy parameters                 |
| MI-ROP  | Insert inapplicable dummy operator with unsatisfiable preconditions |
| MI-ROA  | Increase operator arity by adding unused dummy parameters           |
| MI-RPR1 | Add duplicated preconditions conjunctively                          |
| MI-RPR2 | Add dummy predicates disjunctively to preconditions                 |
| MI-REF1 | Duplicate effect literals with negated and non-negated copies       |
| MI-REF2 | Add dummy predicates with negated and non-negated effects           |

**Total: 9 variants**

## Solvability Constraints (`SC-XXX`)

These modifications deliberately introduce **semantic inconsistencies** that lead to unsolvable planning tasks by
creating dead-end states.

| Domain | Description                                                     |
|--------|-----------------------------------------------------------------|
| SC-DEF | Remove a goal-achieving effect from a duplicated operator       |
| SC-RPD | Add a dummy predicate that cannot be removed, blocking the goal |
| SC-APD | Remove goal-relevant effects using alternating predicate logic  |
| SC-COP | Compose a new operator that removes goal-relevant effects       |

**Total: 4 variants**

## Summary

- **Total variants:** 35
- **Applied per domain:** 6 domains × 35 variants = **210 modified domains**

<p align="right">(<a href="#readme-top">back to top</a>)</p>
