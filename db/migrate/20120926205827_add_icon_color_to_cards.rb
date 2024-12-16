class AddIconColorToCards < ActiveRecord::Migration
  def change
    add_column :cards, :icon_color, :string
  end
end
