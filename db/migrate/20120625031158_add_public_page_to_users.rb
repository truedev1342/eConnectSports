class AddPublicPageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_page, :boolean
  end
end
