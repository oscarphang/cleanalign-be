# Data Model: cleanalign

**Feature**: Service Schedule App
**Spec**: `/Users/oscar/dev/RandD/cleanalign/specs/001-create-a-project/spec.md`

This document defines the data structures for the core entities of the application using the Elixir Ash framework conventions.

## Ash Domains
The application will be organized into the following Ash domains:
- `Cleanalign.Accounts`: Manages users and roles.
- `Cleanalign.Properties`: Manages properties.
- `Cleanalign.ServiceCompanies`: Manages service companies.
- `Cleanalign.Schedules`: Manages service schedules.

---

## Entity Definitions

### 1. `Cleanalign.Accounts.User`
Represents a user of the system who can log in and be assigned roles.

**Ash Resource:**
```elixir
defmodule Cleanalign.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  relationships do
    many_to_many :roles, Cleanalign.Accounts.Role,
      through: Cleanalign.Accounts.UserRole,
      source_attribute_on_join_resource: :user_id,
      destination_attribute_on_join_resource: :role_id
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
      end
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
```

### 2. `Cleanalign.Accounts.Role`
Represents the roles a user can have (e.g., `superuser`, `property_manager`, `service_company`).

**Ash Resource:**
```elixir
defmodule Cleanalign.Accounts.Role do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :atom, allow_nil?: false, constraints: [
      one_of: [:superuser, :property_manager, :service_company]
    ]
  end

  identities do
    identity :unique_name, [:name]
  end
end
```
*(A `UserRole` join resource is implied for the many-to-many relationship)*

---

### 3. `Cleanalign.Properties.Property`
Represents a physical property that requires servicing.

**Ash Resource:**
```elixir
defmodule Cleanalign.Properties.Property do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :building_name, :string
    attribute :description, :string
    attribute :max_pax, :integer, allow_nil?: false, constraints: [min: 1]
    attribute :calendar_url, :string
  end

  relationships do
    belongs_to :user, Cleanalign.Accounts.User,
      attribute_type: :uuid,
      allow_nil?: false

    belongs_to :service_company, Cleanalign.ServiceCompanies.ServiceCompany,
      attribute_type: :uuid,
      allow_nil?: true # Can be unassigned initially
  end
end
```

---

### 4. `Cleanalign.ServiceCompanies.ServiceCompany`
Represents a company that provides services to properties.

**Ash Resource:**
```elixir
defmodule Cleanalign.ServiceCompanies.ServiceCompany do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :cutoff_day, :integer, allow_nil?: false, constraints: [min: 1, max: 31]
  end

  relationships do
    # The user who manages this service company account
    belongs_to :user, Cleanalign.Accounts.User,
      attribute_type: :uuid,
      allow_nil?: false
  end
end
```

---

### 5. `Cleanalign.Schedules.ServiceSchedule`
Represents a scheduled service for a specific property.

**Ash Resource:**
```elixir
defmodule Cleanalign.Schedules.ServiceSchedule do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :service_at, :utc_datetime, allow_nil?: false
    attribute :is_back_to_back, :boolean, default: false, allow_nil?: false
    attribute :remark, :string
    attribute :pax, :integer, allow_nil?: false, constraints: [min: 1]
  end

  relationships do
    belongs_to :property, Cleanalign.Properties.Property,
      attribute_type: :uuid,
      allow_nil?: false
  end
end
```
