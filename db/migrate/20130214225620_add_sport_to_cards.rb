class AddSportToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :sport, :string
  end
end
