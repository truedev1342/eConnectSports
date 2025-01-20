class AddBackgroundTileToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :background_tile, :boolean
  end
end
