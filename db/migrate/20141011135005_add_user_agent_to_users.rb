class AddUserAgentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_agent, :string
  end
end
