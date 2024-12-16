class AddBackgroundToCards < ActiveRecord::Migration
  def change
    add_column :cards, :background, :string
  end
end
