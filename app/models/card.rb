class Card < ActiveRecord::Base
    has_one :customer

    def self.validate_card(codigo, numero)
      Rails.logger.info "codigo: #{codigo}, numero: #{numero}"
      Card.find_by_code_and_number(codigo,numero)
    end

    def self.validate_fecha(numero, fechaCard)
      Rails.logger.info "numero: #{numero}, fecha: #{fechaCard}"
      card = Card.find_by_number(numero)
      fecha = card.date_expired.strftime("%d/%m/%Y").split("/")[1..-1]
      Rails.logger.info "fecha de tarjeta #{fecha}"
      fecha = fecha.join("/").to_s
      Rails.logger.info "fecha de tarjeta actualizada  #{fecha} y #{fechaCard}"
      fecha.eql?(fechaCard) ? true : false
    end
end 