class Invoice < ActiveRecord::Base
  belongs_to :store
  has_many :repairs
  attr_accessible :issued, :number, :paid, :paid_date, :total, :store_id
  
  def update_total_and_save!
    self.total = 0.0
    repairs.each do |repair|
      self.total += repair.price
    end
    save!
  end
  
  def self.for_date(invoice_date)
    Invoice.where('issued = ?', invoice_date)
  end
end
