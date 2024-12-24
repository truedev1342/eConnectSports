class AddNameColorToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :name_color, :string
  end
end
