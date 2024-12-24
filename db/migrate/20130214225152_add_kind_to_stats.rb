class AddKindToStats < ActiveRecord::Migration[5.2]
  def change
    add_column :stats, :kind, :string
  end
end
