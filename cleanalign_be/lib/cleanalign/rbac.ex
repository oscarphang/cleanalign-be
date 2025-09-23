defmodule Cleanalign.RBAC do
  def is_admin(actor, _) do
    Enum.any?(actor.roles, fn role -> role.name == :superuser end)
  end

  def is_property_manager(actor, _) do
    Enum.any?(actor.roles, fn role -> role.name == :property_manager end)
  end

  def is_service_company(actor, _) do
    Enum.any?(actor.roles, fn role -> role.name == :service_company end)
  end
end
