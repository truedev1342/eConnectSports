class AddSportToCards < ActiveRecord::Migration
  def change
    add_column :cards, :sport, :string
  end
end
