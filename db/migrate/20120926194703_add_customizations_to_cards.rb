class AddCustomizationsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :background1_color, :string
    add_column :cards, :background2_color, :string
    add_column :cards, :address_color, :string
    add_column :cards, :details_color, :string
  end
end
