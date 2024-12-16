class AddAdvancedDataFieldToCards < ActiveRecord::Migration
  def change
    add_column :cards, :advanced_data, :text
  end
end
