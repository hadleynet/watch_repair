class Repair < ActiveRecord::Base
  belongs_to :store
  belongs_to :invoice
  attr_accessible :item, :job, :name, :price, :received, :returned, :serial, :service, :store_id
  
  def self.unassigned(store_id, returned)
    Repair.where('store_id = ? AND returned = ? AND invoice_id IS NULL', store_id, returned)
  end
  
  def self.stores_with_repairs(returned)
    Repair.select('DISTINCT store_id').where('returned = ? AND invoice_id IS NULL', returned)
  end
  
  def batch_count
    Repair.count(:item, :conditions => ['job = ? AND received = ? AND store_id = ?', self.job, self.received, self.store_id])
  end
end
