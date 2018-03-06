class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:deliver]

  # GET /shipments
  def index
    @shipments = Shipment.where(delivered_at: nil).preload(:vendor)
    @delay_timing_stats = DeliveryTimingStat.all
  end

  # GET /shipments/new
  def new
    @shipment = Shipment.new
  end

  # POST /shipments
  def create

    @shipment = Shipment.new(shipment_params)

    respond_to do |format|
      if @shipment.save
        format.html { redirect_to '/shipments', notice: 'Shipment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # POST /shipments/{id}/deliver
  def deliver
    @shipment.delivered_at = DateTime.now
    @shipment.save
    respond_to do |format|
      format.html { redirect_to shipments_url, notice: 'Shipment was successfully delivered.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      @shipment = Shipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:order_number, :vendor_id, :tracking_number, :address, :zipcode, :delivered_at)
    end
end
