class Store < ActiveRecord::Base
  has_many :invoices
  attr_accessible :city, :contact, :email, :fax, :name, :street, :tel, :zip, :state
  
  def self.ordered_by_name
    Store.order('name ASC')
  end
end
