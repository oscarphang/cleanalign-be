defmodule Cleanalign.Accounts do
  use Ash.Domain

  resources do
    resource Cleanalign.Accounts.User
    resource Cleanalign.Accounts.Role
    resource Cleanalign.Accounts.UserRole
    resource Cleanalign.Accounts.UserToken
  end
end