class AddAdvancedDataFieldToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :advanced_data, :text
  end
end
