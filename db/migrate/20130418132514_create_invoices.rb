class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :store
      t.integer :number
      t.date :issued
      t.boolean :paid
      t.date :paid_date
      t.decimal :total, :precision => 8, :scale => 2

      t.timestamps
    end
    add_index :invoices, :store_id
    add_index :invoices, :number
    add_index :invoices, :issued
  end
end
