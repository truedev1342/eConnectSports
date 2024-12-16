class AddBackgroundTileToPublicPages < ActiveRecord::Migration
  def change
    add_column :public_pages, :background_tile, :boolean
  end
end
