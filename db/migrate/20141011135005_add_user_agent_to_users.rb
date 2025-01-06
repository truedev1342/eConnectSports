class AddUserAgentToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :user_agent, :string
  end
end
