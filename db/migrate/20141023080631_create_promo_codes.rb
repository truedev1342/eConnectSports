class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.string :code
      t.integer :cards, default: 1
      t.boolean :used, default: false
      t.integer :user_id
      
      t.timestamps
    end
  end
end
