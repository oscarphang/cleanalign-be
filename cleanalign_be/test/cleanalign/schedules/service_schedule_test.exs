defmodule Cleanalign.Schedules.ServiceScheduleTest do
  use Cleanalign.DataCase, async: true

  alias Cleanalign.Schedules.ServiceSchedule
  alias Cleanalign.Accounts.User
  alias Cleanalign.ServiceCompanies.ServiceCompany
  alias Cleanalign.Properties.Property

  setup do
    {:ok, user} =
      Ash.Changeset.for_create(User, :register_with_password, %{
        email: "test@example.com",
        password: "password"
      })
      |> Ash.create()

    Ash.set_context(%{actor: user})

    {:ok, %{user: user}}
  end

  describe "cutoff day validation" do
    test "prevents scheduling after the cutoff day", %{user: user} do
      {:ok, service_company} =
        Ash.Changeset.for_create(ServiceCompany, :create, %{
          name: "Test Company",
          cutoff_day: 15,
          user_id: user.id
        })
        |> Ash.create()

      {:ok, property} =
        Ash.Changeset.for_create(Property, :create, %{
          name: "Test Property",
          service_company_id: service_company.id,
          user_id: user.id,
          max_pax: 1
        })
        |> Ash.create()

      # Simulate being after the cutoff day (e.g., Jan 16th)
      Timex.travel(Date.from_iso8601!("2024-01-16"), fn ->
        attrs = %{
          property_id: property.id,
          service_at: "2024-02-10T10:00:00Z", # Scheduling for the next month
          pax: 1
        }

        changeset = Ash.Changeset.for_create(ServiceSchedule, :create, attrs)

        {:error, result} = Ash.create(changeset)

        assert %Ash.Error.Invalid{
                 errors: [
                   %Ash.Error.Changes.InvalidAttribute{
                     message: "You can only schedule for the current month after the 15th."
                   }
                 ]
               } = result
      end)
    end

    test "allows scheduling before the cutoff day", %{user: user} do
      {:ok, service_company} =
        Ash.Changeset.for_create(ServiceCompany, :create, %{
          name: "Test Company",
          cutoff_day: 15,
          user_id: user.id
        })
        |> Ash.create()

      {:ok, property} =
        Ash.Changeset.for_create(Property, :create, %{
          name: "Test Property",
          service_company_id: service_company.id,
          user_id: user.id,
          max_pax: 1
        })
        |> Ash.create()

      # Simulate being before the cutoff day (e.g., Jan 14th)
      Timex.travel(Date.from_iso8601!("2024-01-14"), fn ->
        attrs = %{
          property_id: property.id,
          service_at: "2024-02-10T10:00:00Z", # Scheduling for the next month
          pax: 1
        }

        changeset = Ash.Changeset.for_create(ServiceSchedule, :create, attrs)

        assert {:ok, _} = Ash.create(changeset)
      end)
    end
  end
end
