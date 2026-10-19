class AddUrlAliasToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :url_alias, :string
    add_index  :cards, :url_alias
  end
end
