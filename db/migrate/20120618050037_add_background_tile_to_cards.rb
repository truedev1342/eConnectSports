class AddBackgroundTileToCards < ActiveRecord::Migration
  def change
    add_column :cards, :background_tile, :boolean
  end
end
