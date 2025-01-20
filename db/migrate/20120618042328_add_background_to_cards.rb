class AddBackgroundToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :background, :string
  end
end
