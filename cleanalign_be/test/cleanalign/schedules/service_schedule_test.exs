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
        password: "password",
        password_confirmation: "password"
      })
      |> Ash.create()

    {:ok, %{user: user}}
  end

  describe "in_reporting_period? calculation" do
    test "returns true for dates within the reporting period", %{user: user} do
      {:ok, service_company} =
        Ash.Changeset.for_create(ServiceCompany, :create, %{
          name: "Test Company",
          cutoff_day: 15,
          user_id: user.id
        })
        |> Ash.create(actor: user)

      {:ok, property} =
        Ash.Changeset.for_create(Property, :create, %{
          name: "Test Property",
          service_company_id: service_company.id,
          user_id: user.id,
          max_pax: 1
        })
        |> Ash.create(actor: user)

      {:ok, schedule} =
        Ash.Changeset.for_create(ServiceSchedule, :create, %{
          property_id: property.id,
          service_at: ~U[2024-01-20 10:00:00Z],
          pax: 1
        })
        |> Ash.create(actor: user)

      # Today is Jan 16th, so reporting period is Jan 15th to Feb 15th
      assert Ash.load!(schedule, :in_reporting_period?, context: %{today: ~D[2024-01-16]}).in_reporting_period?
    end

    test "returns false for dates outside the reporting period", %{user: user} do
      {:ok, service_company} =
        Ash.Changeset.for_create(ServiceCompany, :create, %{
          name: "Test Company",
          cutoff_day: 15,
          user_id: user.id
        })
        |> Ash.create(actor: user)

      {:ok, property} =
        Ash.Changeset.for_create(Property, :create, %{
          name: "Test Property",
          service_company_id: service_company.id,
          user_id: user.id,
          max_pax: 1
        })
        |> Ash.create(actor: user)

      {:ok, schedule} =
        Ash.Changeset.for_create(ServiceSchedule, :create, %{
          property_id: property.id,
          service_at: ~U[2024-02-20 10:00:00Z],
          pax: 1
        })
        |> Ash.create(actor: user)

      # Today is Jan 16th, so reporting period is Jan 15th to Feb 15th
      refute Ash.load!(schedule, :in_reporting_period?, context: %{today: ~D[2024-01-16]}).in_reporting_period?
    end
  end
end
