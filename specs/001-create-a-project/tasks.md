# Tasks: Create a Project

**Input**: Design documents from `/specs/001-create-a-project/`
**Prerequisites**: plan.md, research.md, data-model.md

## Phase 3.1: Project Setup
- [x] T001: Create a new Phoenix project named `cleanalign`.
- [x] T002: Add Ash, AshPostgres, AshAuthentication, AshRBAC, and Backpex as dependencies in `mix.exs`.
- [x] T003: Configure the development database in `config/dev.exs`.
- [x] T004: Create the development database with `mix ecto.create`.
- [x] T005: Configure linting and formatting tools (e.g., `credo`, `mix format`).

## Phase 3.2: Core Data Model (Ash Resources)
- [x] T006: [P] Create the `Cleanalign.Accounts` domain and the `User` resource in `lib/cleanalign/accounts/user.ex`.
- [x] T007: [P] Create the `Role` resource in `lib/cleanalign/accounts/role.ex` and the `UserRole` join resource.
- [x] T008: [P] Create the `Cleanalign.Properties` domain and the `Property` resource in `lib/cleanalign/properties/property.ex`.
- [x] T009: [P] Create the `Cleanalign.ServiceCompanies` domain and the `ServiceCompany` resource in `lib/cleanalign/service_companies/service_company.ex`.
- [x] T010: [P] Create the `Cleanalign.Schedules` domain and the `ServiceSchedule` resource in `lib/cleanalign/schedules/service_schedule.ex`.
- [ ] T011: Create initial migration for all Ash resources with `mix ash_postgres.generate_migrations` and run it with `mix ecto.migrate`.

## Phase 3.3: Business Logic & Authorization
- [ ] T012: Implement the "cutoff day" validation logic in the `ServiceSchedule` resource based on `research.md`.
- [ ] T013: Implement the external calendar conflict check logic in the `ServiceSchedule` resource based on `research.md`.
- [ ] T014: Configure `ash_rbac` policies for all resources to define permissions for `superuser`, `property_manager`, and `service_company` roles.
- [ ] T015: Set up `AshAuthentication` with the `password` strategy for the `User` resource.

## Phase 3.4: Admin Panel (Backpex)
- [ ] T016: [P] Create the Backpex resource for `User` management.
- [ ] T017: [P] Create the Backpex resource for `Role` management.
- [ ] T018: [P] Create the Backpex resource for `Property` management.
- [ ] T019: [P] Create the Backpex resource for `ServiceCompany` management.
- [ ] T020: [P] Create the Backpex resource for `ServiceSchedule` management.
- [ ] T021: Mount the Backpex dashboard in the Phoenix router at `/admin`.

## Phase 3.5: Polish & Testing
- [ ] T022: [P] Write ExUnit tests for the "cutoff day" business logic.
- [ ] T023: [P] Write ExUnit tests for the calendar conflict check logic.
- [ ] T024: [P] Write ExUnit tests for RBAC policies to ensure correct permissions.
- [ ] T025: Manually test the admin panel functionality by following the scenarios in `quickstart.md`.

## Dependencies
- **T001-T005** (Setup) must be completed before all other tasks.
- **T006-T010** (Data Model) can be done in parallel but must be completed before **T011**.
- **T011** (Migration) must be completed before **T012-T025**.
- **T012-T015** (Business Logic) should be completed before **T016-T021** (Admin Panel) and **T022-T025** (Testing).
- **T016-T020** (Backpex Resources) can be done in parallel.

## Parallel Example
The initial data model and Backpex resources can be created in parallel.

```
# Launch T006-T010 together:
Task: "Create the User resource in lib/cleanalign/accounts/user.ex"
Task: "Create the Role resource in lib/cleanalign/accounts/role.ex"
Task: "Create the Property resource in lib/cleanalign/properties/property.ex"
Task: "Create the ServiceCompany resource in lib/cleanalign/service_companies/service_company.ex"
Task: "Create the ServiceSchedule resource in lib/cleanalign/schedules/service_schedule.ex"

# Launch T016-T020 together after business logic is done:
Task: "Create the Backpex resource for User management"
Task: "Create the Backpex resource for Role management"
Task: "Create the Backpex resource for Property management"
Task: "Create the Backpex resource for ServiceCompany management"
Task: "Create the Backpex resource for ServiceSchedule management"
```
