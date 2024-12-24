class AddAdvancedDataFieldToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :advanced_data, :text
  end
end
