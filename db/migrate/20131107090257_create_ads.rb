class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.text :body
      t.integer :user_owner
      t.integer :type
      t.integer :woeid_code
      t.string :ip

      t.timestamps
    end
  end
end
