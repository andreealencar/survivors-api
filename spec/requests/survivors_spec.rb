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
end