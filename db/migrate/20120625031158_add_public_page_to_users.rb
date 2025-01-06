class AddPublicPageToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :public_page, :boolean
  end
end
