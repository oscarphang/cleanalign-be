# Implementation Plan: cleanalign

**Branch**: `001-create-a-project` | **Date**: 2025-09-18 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/Users/oscar/dev/RandD/cleanalign/specs/001-create-a-project/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Fill the Constitution Check section based on the content of the constitution document.
4. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
6. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, `GEMINI.md` for Gemini CLI, `QWEN.md` for Qwen Code or `AGENTS.md` for opencode).
7. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
9. STOP - Ready for /tasks command
```

## Summary
The project is a service scheduling application named `cleanalign`. It allows property managers to manage properties, assign service companies, and schedule services. The system will be built using the Elixir Ash framework, with a PostgreSQL database. An admin panel will be provided using Backpex for all management tasks, and authorization will be handled by `ash_rbac`.

## Technical Context
**Language/Version**: Elixir 1.15+
**Primary Dependencies**: Ash 3.0, AshPostgres 2.0, AshRBAC, AshAuthentication, Backpex, Phoenix 1.7
**Storage**: PostgreSQL
**Testing**: ExUnit
**Target Platform**: Web Application (Admin Panel)
**Project Type**: Web Application
**Performance Goals**: N/A (Standard web performance)
**Constraints**: N/A
**Scale/Scope**: Small to medium number of users (Property Managers, Service Companies).

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project adheres to standard development practices. No specific constitution has been defined yet, so this section is informational. TDD will be applied for business logic components.

## Project Structure

### Documentation (this feature)
```
specs/001-create-a-project/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command) - N/A for this project
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### Source Code (repository root)
```
# Option 2: Web application (when "frontend" + "backend" detected)
# We will use a standard Phoenix project structure, which serves as the backend.
# The "frontend" is the server-rendered Backpex admin panel.
lib/
├── cleanalign/
│   ├── accounts/
│   ├── properties/
│   ├── service_companies/
│   └── schedules/
├── cleanalign_web/
│   ├── components/
│   ├── controllers/
│   └── router.ex
└── cleanalign.ex

test/
├── support/
├── cleanalign_web/
└── cleanalign/
```

**Structure Decision**: Phoenix Web Application structure.

## Phase 0: Outline & Research
Research has been completed to resolve ambiguities in the feature specification regarding the "cutoff day" and "calendarUrl" functionalities. The findings are documented in `research.md`.

**Output**: [research.md](./research.md)

## Phase 1: Design & Contracts
The data model has been designed using Ash resources, and the setup process is documented. API contracts are not applicable as this is not a public-facing API; the Ash resources and Backpex interface serve as the primary contracts.

**Output**: [data-model.md](./data-model.md), [quickstart.md](./quickstart.md)

## Phase 2: Task Planning Approach
The task generation strategy involves breaking down the implementation based on the designed data model and the required features (Authentication, Admin Panel, Business Logic). Tasks are ordered to build foundational layers first (data model) before moving to application logic and UI.

**Output**: [tasks.md](./tasks.md)

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)
**Phase 4**: Implementation (execute tasks.md following constitutional principles)
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A       | N/A        | N/A                                 |


## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS
- [x] All NEEDS CLARIFICATION resolved
- [ ] Complexity deviations documented