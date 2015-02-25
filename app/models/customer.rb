class Customer < ActiveRecord::Base
  has_many :payments
  belongs_to :card
  accepts_nested_attributes_for :card

  def self.validate_customer(numero,name)
    Rails.logger.info "numero: #{numero}"
    res = Customer.find_or_create_by(:identification => numero)
    res.update_attributes(:name => name)
    res.present? ? res.id : ""
  end
  
end