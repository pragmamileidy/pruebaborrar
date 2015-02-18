class Card < ActiveRecord::Base
    has_one :customer

    def self.validate_card(codigo, numero)
      Rails.logger.info "codigo: #{codigo}, numero: #{numero}"
      Card.find_by_code_and_number(codigo,numero)
    end
end 
