class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_type
      t.integer :number
      t.integer :code
      t.date :date_expired

      t.timestamps
    end
  end
end
