# 48 - Assembly Bill-of-Materials Roll-Up - Difficult

## Question Details
- Concept: Recursion over a hierarchy of structures
- Difficulty: Difficult
- Domain: Manufacturing engineering
- Learning Objective: Recursively aggregate quantities through a nested assembly tree.

## Scenario
A production planner needs the total component count for one top-level assembly. Each bill-of-materials node lists the quantity of that component per parent and may contain child subassemblies whose own components must also be counted.

## Function Details
- Define `struct BomNode` with `quantityPerParent`, `childCount`, and an array of up to four pointers to child nodes.
- Function Name: `count_bom_units`
- Function Signature: `unsigned long long count_bom_units(const struct BomNode *node);`
- The root node represents one top-level assembly. For each node, total units equal `quantityPerParent * (1 + sum of each child's total units)`.
- A null node contributes zero. The provided tree is valid, has at most four children per node, and has depth at most six.

## Tasks to Implement
1. Define the recursive node structure.
2. Use a base case for a node with no children.
3. Recursively calculate each child subtotal and apply the parent's quantity multiplier.
4. Return the total number of components required for one top-level assembly.

## Test Cases
| Test Case ID | BOM description | Expected Total Units |
| --- | --- | --- |
| TC01 | root quantity 1, no children | 1 |
| TC02 | root quantity 1; children quantities 2 and 3, no descendants | 6 |
| TC03 | root quantity 1; child quantity 2; grandchild quantity 3 | 9 |
| TC04 | root quantity 1; child A quantity 1 with children 2 and 3; child B quantity 2 | 9 |
| TC05 | root quantity 1; one child quantity 4; each child has a leaf quantity 2 | 13 |

## Expected Deliverables
- A complete implementation of `count_bom_units`.
- A short explanation of the recursive tree calculation.
- Test evidence for all five BOM cases.
