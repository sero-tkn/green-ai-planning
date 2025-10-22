<a id="readme-top"></a>

# Domain Directory

This directory contains the PDDL domain files used in conjunction with the Energy Measurement Framework for Classical
Planners. In the accompanying paper, the variant prefix categories are denoted as **SSC-**, **MRC-** and **TDC-**.
Within this repository, however, the corresponding legacy prefixes **SV-**, **MI-**, and **SC-** remain in use.

To avoid confusion, the mapping between paper notation and repository notation is as follows:

- `SV-` → `SSC-` (Syntactic Structure Choices)
- `MI-` → `MRC-` (Modeling Redundancy Choices)
- `SC-` → `TDC-` (Task Design Choices)
- `MI-RPR2` → `MI-RPR`
- `MI-REF2` → `MI-REF`

Please note that this is purely a naming difference. The semantics, configuration logic, and experimental meaning of the
variants remain fully aligned with the definitions provided in the paper. The original, unmodified domain models are
referred to as `ORG`.

## Syntactic Structure Choices

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
| SV-PRA1/2 | Sort preconditions alphabetically (descending/ascending)                 |
| SV-EFA1/2 | Sort effect literals alphabetically (descending/ascending)               |

**Total: 20 variants**

## Modeling Redundancy Choices

| Domain  | Description                                                         |
|---------|---------------------------------------------------------------------|
| MI-ROB  | Add inert dummy objects to the problem file                         |
| MI-RPD  | Add unused dummy predicates to the domain file                      |
| MI-RPA  | Increase predicate arity by adding dummy parameters                 |
| MI-ROP  | Insert inapplicable dummy operator with unsatisfiable preconditions |
| MI-ROA  | Increase operator arity by adding unused dummy parameters           |
| MI-RPR2 | Add dummy predicates disjunctively to preconditions                 |
| MI-REF2 | Add dummy predicates with negated and non-negated effects           |

**Total: 7 variants**

## Task Design Choices

| Domain | Description                                                     |
|--------|-----------------------------------------------------------------|
| SC-DEF | Remove a goal-achieving effect from a duplicated operator       |
| SC-RPD | Add a dummy predicate that cannot be removed, blocking the goal |
| SC-APD | Remove goal-relevant effects using alternating predicate logic  |
| SC-COP | Compose a new operator that removes goal-relevant effects       |

**Total: 4 variants**

<p align="right">(<a href="#readme-top">back to top</a>)</p>
