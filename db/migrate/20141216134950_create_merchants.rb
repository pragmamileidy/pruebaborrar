class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :username
      t.string :password
      t.string :name
      t.integer :account
      t.string :email

      t.timestamps
    end
  end
end
