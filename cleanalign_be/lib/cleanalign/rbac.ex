defmodule Cleanalign.RBAC do
  defmacro is_admin(actor) do
    quote do
      unquote(actor).roles.name == :superuser
    end
  end

  defmacro is_property_manager(actor) do
    quote do
      unquote(actor).roles.name == :property_manager
    end
  end

  defmacro is_service_company(actor) do
    quote do
      unquote(actor).roles.name == :service_company
    end
  end
end
