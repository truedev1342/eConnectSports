class ChangeParamsFormatInActivities < ActiveRecord::Migration
  def up
  	change_column :activities, :params, :text
  end

  def down
  end
end
