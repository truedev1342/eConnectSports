class AddBackgroundTileToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :background_tile, :boolean
  end
end
