class AddIconColorToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :icon_color, :string
  end
end
