class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :tel
      t.string :fax
      t.string :email
      t.string :contact

      t.timestamps
    end
  end
end
