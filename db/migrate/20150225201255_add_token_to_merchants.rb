class AddTokenToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :token, :string, :unique => true
  end
end
