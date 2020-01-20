require "rails_helper"

RSpec.describe Survivors::Register, :type => :interactor do
  before(:each) {
    @item = create(:item)
    @valid = {
      name: 'Joel',
      gender: 'male',
      age: 44,
      last_location_attributes: { lat: 123.21, lng: 123.21 },
      items_attributes: [{ item_id: @item.id, quantity: 3 }]
    }
  }

  describe "validations" do
    describe "location validations" do
      it "given empty last_location_attributes" do
        invalid = @valid.dup
        invalid[:last_location_attributes] = {}

        result = described_class.call(invalid)

        expect(result).to be_a_failure
        expect(result.errors).to eq({ params: 'invalid params format' })
      end
    end

    describe "items validations" do
      it "given invalid item id" do
        invalid = @valid.dup
        invalid[:items_attributes][0][:item_id] = 9999

        result = described_class.call(invalid)

        expect(result).to be_a_failure
        expect(result.errors).to eq({ items_attributes: 'item with id 9999 not found' })
      end
    end
  end

  describe ".call" do
    it "given valid attributes" do
      result = described_class.call(@valid)
      expect(result).to be_a_success
    end
  end
end