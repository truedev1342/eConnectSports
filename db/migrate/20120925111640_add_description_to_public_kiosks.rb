class AddDescriptionToPublicKiosks < ActiveRecord::Migration[7.2]
  def change
    add_column :public_kiosks, :description, :text
  end
end
