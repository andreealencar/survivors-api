require "rails_helper"

RSpec.describe "Contamination Reports", :type => :request do

  describe "POST - /api/v1/reports/contamination" do
    before(:each) {
      @valid_params = {
        contamination_report: {
          accuser_id: create(:survivor).id,
          suspect_id: create(:survivor).id,
        }
      }
    }
      
    it "register contamination_report" do
      post "/api/v1/reports/contamination", params: @valid_params

      expect(response.status).to eq(201)
    end

    it "don`t register contamination_report" do
      invalid_params = @valid_params.dup
      invalid_params[:contamination_report][:suspect_id] = 9999
      post "/api/v1/reports/contamination", params: invalid_params

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq({"suspect" => ["must exist", "can't be blank"]})
    end
  end

  describe "Reports" do
    before(:each) {
      @survivors = create_list(:survivor, 4)
      @infected = @survivors.last

      @item1 = create(:item, name: 'Item1', points: 1)
      @item2 = create(:item, name: 'Item2', points: 2)
      @item3 = create(:item, name: 'Item3', points: 3)

      create(:inventory_item, survivor: @survivors.first, item: @item1, quantity: 5)
      create(:inventory_item, survivor: @survivors.second, item: @item1, quantity: 3)
      create(:inventory_item, survivor: @survivors.first, item: @item2, quantity: 2)
      create(:inventory_item, survivor: @survivors.second, item: @item2, quantity: 4)
      create(:inventory_item, survivor: @survivors.first, item: @item3, quantity: 3)
      create(:inventory_item, survivor: @survivors.second, item: @item3, quantity: 3)
      create(:inventory_item, survivor: @infected, item: @item1, quantity: 3)
      create(:inventory_item, survivor: @infected, item: @item2, quantity: 3)

      ContaminationReport.create(@survivors.first(3).map { |survivor|
        { accuser: survivor, suspect: @infected }
      })
    }

    it "get infected percentage of survivors" do
      get "/api/v1/reports/infected_percentage"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({"percentage" => 25.0})
    end
      
    it "get not infected percentage of survivors" do
      get "/api/v1/reports/not_infected_percentage"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({"percentage" => 75.0})
    end

    it "get lost points by contamination" do
      get "/api/v1/reports/lost_points"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({"lost_points" => 9})
    end

    it "get lost points by contamination" do
      get "/api/v1/reports/average_amount_items"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({"average_by_item" => {
        "Item1" => 3.67,
        "Item2" => 3.0,
        "Item3" => 2.0
      }})
    end
  end
end