class AddBackgroundTileToPublicPages < ActiveRecord::Migration[5.2]
  def change
    add_column :public_pages, :background_tile, :boolean
  end
end
