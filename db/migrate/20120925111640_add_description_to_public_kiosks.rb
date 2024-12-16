class AddDescriptionToPublicKiosks < ActiveRecord::Migration
  def change
    add_column :public_kiosks, :description, :text
  end
end
