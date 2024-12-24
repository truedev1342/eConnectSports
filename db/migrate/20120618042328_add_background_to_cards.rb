class AddBackgroundToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :background, :string
  end
end
