# Quickstart: cleanalign

**Feature**: Service Schedule App

This guide provides the steps to set up the Elixir project and its dependencies.

## 1. Project Initialization

1.  **Install Elixir and Phoenix**: Ensure you have Elixir 1.15+ and the Phoenix project generator `phx.new` installed.
2.  **Create the Phoenix Project**:
    ```bash
    mix phx.new cleanalign --no-ecto --no-mailer --no-dashboard
    cd cleanalign
    ```
3.  **Configure Database**:
    - Open `config/dev.exs` and `config/test.exs`.
    - Configure the `:cleanalign, Cleanalign.Repo` section with your PostgreSQL credentials. Example:
      ```elixir
      config :cleanalign, Cleanalign.Repo,
        username: "pnd",
        password: "vsjcTRkHS4N4gzsX",
        hostname: "127.0.0.1",
        database: "cleanalign_dev",
        stacktrace: true,
        show_sensitive_data_on_connection_error: true,
        pool_size: 10
      ```
4.  **Create the Database**:
    ```bash
    mix ecto.create
    ```

## 2. Add Dependencies

Add the following dependencies to your `mix.exs` file:

```elixir
def deps do
  [
    # ... existing deps
    {:ash, "~> 3.0"},
    {:ash_postgres, "~> 2.0"},
    {:ash_rbac, "~> 0.2.2"},
    {:backpex, "~> 0.5.0"},
    {:ash_authentication, "~> 4.0"},
    {:ash_authentication_phoenix, "~> 2.0"}
  ]
end
```

Then, fetch the new dependencies:
```bash
mix deps.get
```

## 3. Initial Setup

1.  **Create Ash Domains**:
    Create the directories and API files for each Ash domain:
    - `lib/cleanalign/accounts/accounts.ex`
    - `lib/cleanalign/properties/properties.ex`
    - `lib/cleanalign/service_companies/service_companies.ex`
    - `lib/cleanalign/schedules/schedules.ex`

    Example for `lib/cleanalign/accounts/accounts.ex`:
    ```elixir
    defmodule Cleanalign.Accounts do
      use Ash.Api

      resources do
        resource Cleanalign.Accounts.User
        resource Cleanalign.Accounts.Role
        resource Cleanalign.Accounts.UserRole
      end
    end
    ```

2.  **Create Ash Resources**:
    - Create the resource modules defined in `data-model.md` in their respective domain directories (e.g., `lib/cleanalign/accounts/user.ex`).

3.  **Set up the Repo**:
    - Create `lib/cleanalign/repo.ex`:
    ```elixir
    defmodule Cleanalign.Repo do
      use AshPostgres.Repo, otp_app: :cleanalign

      def installed_extensions, do: ["uuid-ossp", "citext"]
    end
    ```

4.  **Configure Ash**:
    - In `config/config.exs`, add:
    ```elixir
    config :ash, :apis, [
      Cleanalign.Accounts,
      Cleanalign.Properties,
      Cleanalign.ServiceCompanies,
      Cleanalign.Schedules
    ]
    ```

## 4. Run Migrations

1.  **Generate Migrations**:
    ```bash
    mix ash.generate_migrations --name initial_schema
    ```
2.  **Run Migrations**:
    ```bash
    mix ecto.migrate
    ```

## 5. Set up Admin Panel (Backpex)

1.  **Follow Backpex Installation**: Follow the official Backpex installation guide to set up the router, live socket, and necessary configuration.
2.  **Create Backpex Resources**: For each core entity (User, Property, etc.), create a corresponding `Backpex.Resource` module to expose it in the admin panel.

## 6. Run the Application

Once the setup is complete, you can run the Phoenix server:
```bash
mix phx.server
```
The admin panel should be accessible at the path you configured (e.g., `/admin`).
