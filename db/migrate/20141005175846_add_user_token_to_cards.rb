class AddUserTokenToCards < ActiveRecord::Migration
  def change
    add_column :cards, :user_token, :string
  end
end
