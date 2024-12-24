class AddSportToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :sport, :string
  end
end
