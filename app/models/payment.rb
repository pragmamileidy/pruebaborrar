class Payment < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  accepts_nested_attributes_for :merchant
end
