class CreatePublicPages < ActiveRecord::Migration[7.2]
  def change
    create_table :public_pages do |t|
      t.boolean :status
      t.string :background
      t.string :logo
      t.references :user

      t.timestamps
    end
    unless index_exists?(:public_pages, :user_id)
      add_index :public_pages, :user_id
    end
  end
end
