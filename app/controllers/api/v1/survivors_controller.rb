module Api::V1
  class SurvivorsController < ApplicationController
    before_action :set_survivor, only: [:show, :last_location]

    def_param_group :survivor_params do
      param :survivor, Hash,required: true do
        param :name, String, required: true
        param :gender, String, required: true
        param :age, Integer, required: true
        param :last_location_attributes, Hash, required: true do
          param :lat, Float, required: true
          param :lng, Float, required: true
        end
        param :items_attributes, Array, of: Hash, required: true do
          param :item_id, Integer, required: true
          param :quantity, Integer, required: true
        end
      end
    end

    def_param_group :location_params do
      param :location, Hash, required: true do
        param :lat, Float, required: true
        param :lng, Float, required: true
      end
    end

    def_param_group :trade_params do
      param :trade, Hash,required: true do
        param :survivor_1_id, Integer, required: true
        param :survivor_2_id, Integer, required: true
        param :survivor_1_items, Array, of: Hash, required: true do
          param :item_id, Integer, required: true
          param :quantity, Integer, required: true
        end
        param :survivor_2_items, Array, of: Hash, required: true do
          param :item_id, Integer, required: true
          param :quantity, Integer, required: true
        end
      end
    end

    def_param_group :survivor_response do
      property :id, Integer
      property :name, String
      property :gender, String
      property :age, Integer
      property :last_location, Hash do
        property :lat, Float
        property :lng, Float
      end
      property :inventory_items, Array, of: Hash do
        property :quantity, Integer
        property :item, Hash do
          property :name, String
          property :points, Integer
        end
      end
    end
  
    api :GET, '/survivors'
    returns array_of: :survivor_response, :desc => "Returns a survivors list"
    def index
      @survivors = Survivor.all
  
      render json: SurvivorBlueprint.render(@survivors)
    end
  
    api :GET, '/survivors/:id'
    param :id, :number, desc: 'ID of survivor'
    returns :survivor_response, :desc => "Returns a survivor"
    def show
      render json: SurvivorBlueprint.render(@survivor)
    end
  
    api :POST, '/survivors/'
    param_group :survivor_params
    returns :survivor_response, :desc => "Returns a new survivor"
    def create
      result = Survivors::Register.call(survivor_params)
  
      if result.success?
        render json: SurvivorBlueprint.render(result.survivor), status: :created
      else
        render json: result.errors, status: :unprocessable_entity
      end
    end
  
    api :PUT, '/survivors/:id/last_location'
    param :id, :number, desc: 'ID of survivor'
    param_group :location_params
    returns :survivor_response, :desc => "Returns a survivor data with last location updated"
    def last_location
      if @survivor.last_location.update(location_params)
        render json: SurvivorBlueprint.render(@survivor), status: :ok
      else
        render json: @survivor.last_location.errors, status: :unprocessable_entity
      end
    end

    api :POST, '/survivors/trade'
    param_group :trade_params
    returns code: 204, :desc => "Returns nothing just trade items"
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
          items_attributes: [[:item_id, :quantity]]
        ).to_h
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