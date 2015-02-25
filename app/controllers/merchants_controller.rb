class MerchantsController < ApplicationController
 soap_service namespace: 'urn:WashOut'
 #USER_ID, PASSWORD = "admin", "1234"
 
  soap_action "integer_to_string",
              :args   => :integer,
              :return => :xml
  def integer_to_string
    render :soap => params[:value].to_s
  end

  soap_action "concat",
              :args   => { :a => :string, :b => :string },
              :return => :string
  def concat
    token = SecureRandom.hex(16)
    render :soap => (token)
    #render :soap => (params[:a] + params[:b])
  end

  soap_action "make_payment",
              :args => { 
                      :username => :string,
                      :password => :string,
                      :customerName => :string,
                      :customerID => :string,
                      :customerEmail => :string,
                      :total => :string
              },
              :return => :json
  def make_payment
    a = Payment.first
    render :soap => (params[:username] + " " + params[:password] + " #{a.id}")
  end
end
