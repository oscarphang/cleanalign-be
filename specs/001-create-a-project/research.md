# Research & Discovery: cleanalign

**Feature**: Service Schedule App
**Spec**: `/Users/oscar/dev/RandD/cleanalign/specs/001-create-a-project/spec.md`

This document addresses ambiguities identified in the feature specification and outlines the technical direction for the project.

## 1. Unresolved Questions from `spec.md`

### 1.1. Service Company "Cutoff Day"
- **Question**: What happens if a Service Company's cutoff day for scheduling is passed?
- **Decision**: The system will prevent a Property Manager from creating or updating a `ServiceSchedule` for a date that is on or after the `cutoff_day` of the month. The `cutoff_day` is an integer representing the day of the month (e.g., 25). For any given month, scheduling for the next month is disallowed after this day of the current month.
- **Rationale**: This provides a clear, predictable rule for service companies to manage their upcoming schedules. It prevents last-minute changes and ensures adequate planning time.
- **Alternatives Considered**:
    - A floating window (e.g., "no scheduling within 5 days"). This was rejected as it's more complex to calculate and less predictable for monthly planning cycles.

### 1.2. External Calendar Integration (`calendarUrl`)
- **Question**: How are conflicts handled if a property's calendar (from `calendarUrl`) has a scheduling conflict?
- **Decision**: The `calendarUrl` will be assumed to be a publicly accessible iCalendar (`.ics`) feed. When a `ServiceSchedule` is created or updated, the system will fetch events from this URL for the proposed date. If any event on the external calendar overlaps with the proposed service time, the system will reject the creation/update with a conflict error message. This check is a validation step, not a synchronization.
- **Rationale**: This approach prevents double-booking without the complexity of a full two-way calendar sync. It leverages a standard format (`.ics`) and places the responsibility of maintaining the external calendar on the Property Manager.
- **Alternatives Considered**:
    - Google Calendar API/OAuth Integration: Rejected due to excessive complexity for this stage. It would require managing user authentication tokens and permissions, which is beyond the initial scope.
    - No conflict check: Rejected as it would undermine the reliability of the scheduling system and lead to operational issues.

## 2. Technology Stack Best Practices

### 2.1. Elixir & Ash Framework
- **Decision**: We will use the Ash framework for data modeling and business logic. The project will be structured into Ash domains corresponding to the key entities: `Accounts`, `Properties`, `ServiceCompanies`, and `Schedules`.
- **Rationale**: Ash provides a declarative approach that accelerates development, ensures consistency, and comes with powerful built-in features like sorting, filtering, and calculations. It is well-suited for building the resource-based logic this application requires.

### 2.2. Role-Based Access Control (RBAC)
- **Decision**: We will use the `ash_rbac` library for authorization. A `Role` entity will be created (`superuser`, `property_manager`, `service_company`), and users will be assigned roles. Policies will be defined declaratively within the Ash resources to control access.
- **Rationale**: `ash_rbac` integrates seamlessly with Ash resources and provides a clear, maintainable way to manage permissions. It avoids scattering authorization logic throughout the codebase.

### 2.3. Admin Panel
- **Decision**: The admin panel will be built using `Backpex`. We will create Backpex resource modules for each of the core Ash resources.
- **Rationale**: Backpex is designed to work with Ash and provides a quick way to build a full-featured admin interface with minimal custom code. This significantly speeds up the development of the management portions of the application.
