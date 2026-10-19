class AddNameColorToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :name_color, :string
  end
end
