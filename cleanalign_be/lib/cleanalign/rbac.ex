defmodule Cleanalign.RBAC do
  def is_admin do
    {Ash.Policy.Check.Function, fun: fn actor, _ -> Enum.any?(actor.roles, fn role -> role.name == :superuser end) end}
  end

  def is_property_manager do
    {Ash.Policy.Check.Function, fun: fn actor, _ -> Enum.any?(actor.roles, fn role -> role.name == :property_manager end) end}
  end

  def is_service_company do
    {Ash.Policy.Check.Function, fun: fn actor, _ -> Enum.any?(actor.roles, fn role -> role.name == :service_company end) end}
  end
end
