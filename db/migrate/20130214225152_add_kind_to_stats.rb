class AddKindToStats < ActiveRecord::Migration[7.2]
  def change
    add_column :stats, :kind, :string
  end
end
