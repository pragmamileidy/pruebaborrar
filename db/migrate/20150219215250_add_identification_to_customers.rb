class AddIdentificationToCustomers < ActiveRecord::Migration
  def change
    add_index :customers, :identification, :unique => true
  end
end
