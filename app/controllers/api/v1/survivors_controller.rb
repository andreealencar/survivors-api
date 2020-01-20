module Api::V1
  class SurvivorsController < ApplicationController
    before_action :set_survivor, only: [:show, :last_location]
  
    # GET /survivors
    def index
      @survivors = Survivor.all
  
      render json: SurvivorBlueprint.render(@survivors)
    end
  
    # GET /survivors/1
    def show
      render json: SurvivorBlueprint.render(@survivor)
    end
  
    # POST /survivors
    def create
      result = Survivors::Register.call(survivor_params)
  
      if result.success?
        render json: SurvivorBlueprint.render(result.survivor), status: :created
      else
        render json: result.errors, status: :unprocessable_entity
      end
    end
  
    # PUT /survivors/1/last_location
    def last_location
      if @survivor.last_location.update(location_params)
        render json: SurvivorBlueprint.render(@survivor), status: :ok
      else
        render json: @survivor.last_location.errors, status: :unprocessable_entity
      end
    end

    # POST /survivors/trade
    def trade
      result = Survivors::Trade.call(trade_params)
  
      if result.success?
        head :no_content
      else
        render json: result.errors, status: :unprocessable_entity
      end
    end
  
    private
      def set_survivor
        @survivor = Survivor.find(params[:id])
      end
  
      def survivor_params
        params.require(:survivor).permit(
          :name, 
          :age,
          :gender,
          last_location_attributes: [:lat, :lng],
          items_attributes: [[:id, :quantity]])
      end

      def trade_params
        params.require(:trade).permit(
          :survivor_1_id,
          :survivor_2_id,
          survivor_1_items: [[:item_id, :quantity]],
          survivor_2_items: [[:item_id, :quantity]]
        ).to_h
      end
  
      def location_params
        params.require(:location).permit(:lat, :lng)
      end
  end
end