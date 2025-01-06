class AddUserTokenToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :user_token, :string
  end
end
