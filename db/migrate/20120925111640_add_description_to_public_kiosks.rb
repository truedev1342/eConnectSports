class AddDescriptionToPublicKiosks < ActiveRecord::Migration[5.2]
  def change
    add_column :public_kiosks, :description, :text
  end
end
