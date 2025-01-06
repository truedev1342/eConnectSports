class ChangeParamsFormatInActivities < ActiveRecord::Migration[7.2]
  def up
  	change_column :activities, :params, :text
  end

  def down
  end
end
