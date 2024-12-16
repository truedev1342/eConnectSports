class AddUrlAliasToCards < ActiveRecord::Migration
  def change
    add_column :cards, :url_alias, :string
    add_index  :cards, :url_alias
  end
end
