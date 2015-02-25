class PaymentsController < ApplicationController
 before_action :set_payment, only: [:show, :edit, :update, :destroy]
   #USER_ID, PASSWORD = "admin", "1234"
 
   # Require authentication only for edit and delete operation
   #before_filter :authenticate
  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    Rails.logger.info("#{@payment.attributes}")
    respond_to do |format|
      if @payment.save
        @payment.update_attributes(:merchant_id => Merchant.first.id, :status => "OK")
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        @payment.update_attributes(:customer_id => params[:numero])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def validate_card
    result = Card.validate_card(params[:codigo], params[:numero])
    Rails.logger.info("este es el resultado de validar tarjeta #{result}")
    respond_to do |format|
      if result.present?
        format.html do
          redirect_to '/'
        end
        format.json { render json: result.to_json }
      else
        format.html { render new_payment_url} ## Specify the format in which you are rendering "new" page
        format.json { render json: result } ## You might want to specify a json format as well
      end
    end
  end

  def validate_fecha
    result = Card.validate_fecha(params[:numero], params[:fecha])
    Rails.logger.info("este es el resultado de validar fecha #{result}")

    respond_to do |format|
      if result.present?
        format.html do
          redirect_to '/'
        end
        format.json { render json: result.to_json }
      else
        format.html { render new_payment_url} ## Specify the format in which you are rendering "new" page
        format.json { render json: result } ## You might want to specify a json format as well
      end
    end
  end

  def validate_customer
    Rails.logger.info("LLEGANDO AL METODO VALIDAR CLIENTE")
    result = Customer.validate_customer(params[:numero], params[:name])
    if result.present?
      render json: result
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      #params.require(:payment).permit!
      #params.require(:payment).permit(:amount, :description)
      params.require(:payment).permit(:amount, :description, :customer_id, :status)
    end
 #  def authenticate
 #     authenticate_or_request_with_http_basic do |id, password| 
 #         id == USER_ID && password == PASSWORD
 #     end
 #  end
end
