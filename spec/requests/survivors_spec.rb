require "rails_helper"

RSpec.describe "Survivors management", :type => :request do
  before(:each) {
    @survivors = create_list(:survivor, 3)

    @survivor  = @survivors.first
    create(:location, survivor: @survivor)

    @item_1 = create(:item, points: 4)
    @item_2 = create(:item, points: 2)
  }

  describe "GET - /api/v1/survivors" do
    it "get list of 3 survivors" do
      get "/api/v1/survivors"

      expect(JSON.parse(response.body).size).to eq(3)
      expect(response.body).to eq(SurvivorBlueprint.render(@survivors))
      expect(response.status).to eq(200)
    end
  end

  describe "GET - /api/v1/survivors/:id" do
    it "get specific survivors" do
      get "/api/v1/survivors/#{@survivor.id}"

      expect(response.body).to eq(SurvivorBlueprint.render(@survivor))
      expect(response.status).to eq(200)
    end
  end

  describe "POST - /api/v1/survivors/" do
    before(:each) {
      @survivor_params = {
        survivor: {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: [{ item_id: @item_1.id, quantity: 3 }]
        }
      }
    }

    it "register survivor" do
      post "/api/v1/survivors/", params: @survivor_params, as: :json
      
      expect(response.status).to eq(201)
    end
    
    it "don`t register survivor" do
      invalid = @survivor_params.dup
      invalid[:survivor][:name] = nil

      post "/api/v1/survivors/", params: invalid, as: :json

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq('params' => 'invalid params format')
    end
  end

  describe "PUT - /api/v1/survivors/:id/last_location" do
    before(:each) {
      @location_params = {
        location: {
          lat: 123.21,
          lng: 123.21
        }
      }
    }

    it "update last location of survivor" do
      put "/api/v1/survivors/#{@survivor.id}/last_location", params: @location_params

      expect(response.body).to eq(SurvivorBlueprint.render(@survivor))
      expect(response.status).to eq(200)
    end

    it "don`t update last location of survivor" do
      invalid = @location_params.dup
      invalid[:location][:lat] = nil
      
      put "/api/v1/survivors/#{@survivor.id}/last_location", params: invalid

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq({
        "lat" => ['can\'t be blank']
      })
    end
  end

  describe "POST - /api/v1/survivors/trade/" do
    before(:each) do
      create(:inventory_item, survivor: @survivors.first, item: @item_1, quantity: 1)
      create(:inventory_item, survivor: @survivors.third, item: @item_2, quantity: 2)

      @trade_params = {
        trade: {
          survivor_1_id: @survivors.first.id,
          survivor_2_id: @survivors.third.id,
          survivor_1_items: [ { item_id: @item_1.id, quantity: 1 } ],
          survivor_2_items: [ { item_id: @item_2.id, quantity: 2 } ]
        }
      }
    end
      
    it "trade survivors itens" do
      post "/api/v1/survivors/trade/", params: @trade_params, as: :json

      expect(response.status).to eq(204)
    end

    it "don`t trade survivors itens" do
      invalid = @trade_params.dup
      invalid[:trade][:survivor_1_id] = 9999

      post "/api/v1/survivors/trade/", params: invalid, as: :json

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq({"survivor_1_id"=>"not found"})
    end
  end
end