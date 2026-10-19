class AddBackgroundTileToPublicPages < ActiveRecord::Migration[7.2]
  def change
    add_column :public_pages, :background_tile, :boolean
  end
end
