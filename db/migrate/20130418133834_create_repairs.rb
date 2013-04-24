class CreateRepairs < ActiveRecord::Migration
  def change
    create_table :repairs do |t|
      t.references :store
      t.references :invoice
      t.date :received
      t.date :returned
      t.string :job
      t.string :name
      t.text :item
      t.string :serial
      t.text :service
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
    add_index :repairs, :store_id
    add_index :repairs, :invoice_id
    add_index :repairs, :serial
    add_index :repairs, :received
    add_index :repairs, :returned
  end
end
