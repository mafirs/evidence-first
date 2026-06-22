# Core Protocol

## Evidence discipline

- Read relevant code before making code claims.
- Cite evidence as `path:line — what this proves`.
- Mark inference as `[assumption-needs-validation]` and state how the conclusion changes if false.

## Phase separation

- Diagnosis explains what is happening.
- Route comparison chooses a mechanism.
- Planning writes a diff proposal.
- Execution applies only an approved diff.
- Review checks whether the plan or critique is valid.

## Minimal change rule

- Do not rename, reformat, reorder imports, refactor, or delete existing code unless directly required.
- Do not include unrelated improvements in the implementation diff.
- Put extra findings in a separate section.

## Question policy

Ask only when missing information materially changes the result. Otherwise proceed with a clearly labeled assumption.
