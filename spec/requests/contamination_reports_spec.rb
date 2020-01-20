require "rails_helper"

RSpec.describe "Contamination Reports", :type => :request do

  describe "POST - /api/v1/contamination_reports/" do
    before(:each) do
      @valid_params = {
        contamination_report: {
          accuser_id: create(:survivor).id,
          suspect_id: create(:survivor).id,
        }
      }
    end
      
    it "register contamination_report" do
      post "/api/v1/contamination_reports/", params: @valid_params

      expect(response.status).to eq(201)
    end

    it "don`t register contamination_report" do
      invalid_params = @valid_params.dup
      invalid_params[:contamination_report][:suspect_id] = 9999
      post "/api/v1/contamination_reports/", params: invalid_params

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq({"suspect" => ["must exist", "can't be blank"]})
    end
  end
end