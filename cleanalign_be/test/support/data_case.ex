defmodule Cleanalign.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Cleanalign.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Cleanalign.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cleanalign.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Cleanalign.Repo, {:shared, self()})
    end

    :ok
  end
end
