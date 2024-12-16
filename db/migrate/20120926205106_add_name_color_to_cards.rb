class AddNameColorToCards < ActiveRecord::Migration
  def change
    add_column :cards, :name_color, :string
  end
end
