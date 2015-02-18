class Customer < ActiveRecord::Base
  has_many :payments
  belongs_to :card
  accepts_nested_attributes_for :card
end
