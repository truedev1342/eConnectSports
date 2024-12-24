class ChangeParamsFormatInActivities < ActiveRecord::Migration[5.2]
  def up
  	change_column :activities, :params, :text
  end

  def down
  end
end
