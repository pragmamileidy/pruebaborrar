class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :identification
      t.text :address1

      t.timestamps
    end
  end
end
