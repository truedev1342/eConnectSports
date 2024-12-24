class AddPublicPageToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :public_page, :boolean
  end
end
