class AddCardsToCustomers < ActiveRecord::Migration
  def change
    add_reference :customers, :card, index: true
  end
end
