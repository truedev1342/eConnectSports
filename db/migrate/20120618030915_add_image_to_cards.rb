class AddImageToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :image, :string
  end
end
