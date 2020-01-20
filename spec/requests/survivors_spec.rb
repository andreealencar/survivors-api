require "rails_helper"

RSpec.describe "Survivors management", :type => :request do

  describe "GET - /api/v1/survivors" do
    before(:each) do
      @survivors = create_list(:survivor, 3)
    end
      
    it "get list of 3 survivors" do
      get "/api/v1/survivors"

      expect(JSON.parse(response.body).size).to eq(3)
      expect(response.body).to eq(SurvivorBlueprint.render(@survivors))
      expect(response.status).to eq(200)
    end
  end

  describe "GET - /api/v1/survivors/:id" do
    before(:each) do
      @survivor = create(:survivor)
    end
      
    it "get specific survivors" do
      get "/api/v1/survivors/#{@survivor.id}"

      expect(response.body).to eq(SurvivorBlueprint.render(@survivor))
      expect(response.status).to eq(200)
    end
  end

  describe "POST - /api/v1/survivors/" do
    before(:each) do
      @item = create(:item)

      @valid_params = {
        survivor: {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: [{ id: @item.id, quantity: 3 }]
        }
      }

      @invalid_params = {
        survivor: {
          name: nil,
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: [{ id: @item.id, quantity: 3 }]
        }
      }
    end
      
    it "register survivor" do
      post "/api/v1/survivors/", params: @valid_params

      expect(response.status).to eq(201)
    end

    it "don`t register survivor" do
      post "/api/v1/survivors/", params: @invalid_params

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq(['Name can\'t be blank'])
    end
  end

  describe "PUT - /api/v1/survivors/:id/last_location" do
    before(:each) do
      @valid_params   = { location: { lat: 123.21, lng: 123.21 } }
      @invalid_params = { location: { lat: nil, lng: nil } }

      @survivor = create(:survivor)
      create(:location, survivor: @survivor)
    end
      
    it "update last location of survivor" do
      put "/api/v1/survivors/#{@survivor.id}/last_location", params: @valid_params

      expect(response.body).to eq(SurvivorBlueprint.render(@survivor))
      expect(response.status).to eq(200)
    end

    it "don`t update last location of survivor" do
      put "/api/v1/survivors/#{@survivor.id}/last_location", params: @invalid_params

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq({
        "lat" => ['can\'t be blank'],
        "lng" => ['can\'t be blank']
      })
    end
  end

  describe "POST - /api/v1/survivors/trade/" do
    before(:each) do
      @survivor_1 = create(:survivor)
      @survivor_2 = create(:survivor)

      @item_1 = create(:item, points: 4)
      @item_2 = create(:item, points: 2)

      InventoryItem.create([
        { survivor: @survivor_1, item: @item_1, quantity: 1 },
        { survivor: @survivor_2, item: @item_2, quantity: 2 }
      ])

      @valid_params = {
        trade: {
          survivor_1_id: @survivor_1.id,
          survivor_2_id: @survivor_2.id,
          survivor_1_items: [ { item_id: @item_1.id, quantity: 1 } ],
          survivor_2_items: [ { item_id: @item_2.id, quantity: 2 } ]
        }
      }
    end
      
    it "register survivor" do
      post "/api/v1/survivors/trade/", params: @valid_params, as: :json

      expect(response.status).to eq(204)
    end

    it "don`t register survivor" do
      invalid_params = @valid_params.dup
      invalid_params[:trade][:survivor_1_id] = 9999

      post "/api/v1/survivors/trade/", params: invalid_params, as: :json

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq({"survivor_1_id"=>"not found"})
    end
  end
end