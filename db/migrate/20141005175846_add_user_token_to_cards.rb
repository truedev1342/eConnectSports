class AddUserTokenToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :user_token, :string
  end
end
