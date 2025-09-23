defmodule Cleanalign.RBAC.Test do
  use Cleanalign.DataCase, async: true

  alias Cleanalign.Accounts.User
  alias Cleanalign.Accounts.Role

  setup do
    {:ok, superuser} =
      Ash.Changeset.for_create(User, :register_with_password, %{
        email: "superuser@example.com",
        password: "password",
        password_confirmation: "password"
      })
      |> Ash.create()

    {:ok, property_manager} =
      Ash.Changeset.for_create(User, :register_with_password, %{
        email: "manager@example.com",
        password: "password",
        password_confirmation: "password"
      })
      |> Ash.create()

    {:ok, service_company} =
      Ash.Changeset.for_create(User, :register_with_password, %{
        email: "company@example.com",
        password: "password",
        password_confirmation: "password"
      })
      |> Ash.create()

    {:ok, superuser_role} =
      Ash.Changeset.for_create(Role, :create, %{
        name: :superuser
      })
      |> Ash.create(actor: superuser)

    {:ok, property_manager_role} =
      Ash.Changeset.for_create(Role, :create, %{
        name: :property_manager
      })
      |> Ash.create(actor: superuser)

    {:ok, service_company_role} =
      Ash.Changeset.for_create(Role, :create, %{
        name: :service_company
      })
      |> Ash.create(actor: superuser)

    Ash.Changeset.for_update(superuser, :add_roles, %{roles: [superuser_role]}) |> Ash.update!(actor: superuser)
    Ash.Changeset.for_update(property_manager, :add_roles, %{roles: [property_manager_role]}) |> Ash.update!(actor: superuser)
    Ash.Changeset.for_update(service_company, :add_roles, %{roles: [service_company_role]}) |> Ash.update!(actor: superuser)

    {:ok,
     %{
       superuser: superuser,
       property_manager: property_manager,
       service_company: service_company
     }}
  end

  describe "User policies" do
    test "superuser can do anything", %{superuser: superuser} do
      assert {:ok, _} =
               Ash.Query.for_read(User, actor: superuser) |> Ash.read()
    end

    test "property_manager can read their own user", %{property_manager: property_manager} do
      assert {:ok, _} =
              Ash.Query.for_read(User, actor: property_manager) |> Ash.get(property_manager.id)
    end

    test "property_manager cannot read other users", %{property_manager: property_manager, service_company: service_company} do
      assert {:error, _} =
              Ash.Query.for_read(User, actor: property_manager) |> Ash.get(service_company.id)
    end
  end
end
