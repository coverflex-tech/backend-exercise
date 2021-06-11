defmodule Coverflex.Repo.Migrations.AddIdUserUniqueness do
  use Ecto.Migration

  def change do
    create(unique_index(:users, [:user_id], name: :user_id_unique_index))
  end
end
