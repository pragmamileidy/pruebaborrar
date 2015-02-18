class Merchant < ActiveRecord::Base
  has_many :payments
end
