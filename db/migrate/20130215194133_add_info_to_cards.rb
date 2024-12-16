class AddInfoToCards < ActiveRecord::Migration
  def change
    add_column :cards, :hometown, :string
    add_column :cards, :season, :string
    add_column :cards, :year, :string
    add_column :cards, :league, :string
    add_column :cards, :handed, :string
  end
end
