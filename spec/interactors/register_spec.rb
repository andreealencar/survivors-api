require "rails_helper"

RSpec.describe Survivors::Register, :type => :interactor do
  describe "validations" do
    describe "location validations" do
      before(:each) {
        @item = create(:item)
        @invalid_1 = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: {},
          items_attributes: [{ id: @item.id, quantity: 3 }]
        }

        @invalid_2 = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: [{ lat: 123.21, lng: 123.21 }],
          items_attributes: [{ id: @item.id, quantity: 3 }]
        }

        @invalid_3 = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21 },
          items_attributes: [{ id: @item.id, quantity: 3 }]
        }
      }

      it "given empty last_location_attributes" do
        result = described_class.call(@invalid_1)
        expect(result).to be_a_failure
        expect(result.errors).to eq({ last_location_attributes: 'is required' })
      end

      it "given last_location_attributes as array" do
        result = described_class.call(@invalid_2)
        expect(result).to be_a_failure
        expect(result.errors).to eq({ last_location_attributes: 'must be object' })
      end

      it "given last_location_attributes without lng attribute" do
        result = described_class.call(@invalid_3)
        expect(result).to be_a_failure
        expect(result.errors).to eq({ last_location_attributes: 'must be object with values for lat and lng' })
      end
    end

    describe "items validations" do
      before(:each) {
        @item = create(:item)
        @invalid_1 = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: []
        }

        @invalid_2 = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: { id: @item.id, quantity: 3 }
        }

        @invalid_3 = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: [{ id: @item.id }]
        }

        @invalid_4 = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: [{ id: 9999, quantity: 10 }]
        }
      }

      it "given empty items_attributes" do
        result = described_class.call(@invalid_1)
        expect(result).to be_a_failure
        expect(result.errors).to eq({ items_attributes: 'is required' })
      end

      it "given items_attributes as object" do
        result = described_class.call(@invalid_2)
        expect(result).to be_a_failure
        expect(result.errors).to eq({ items_attributes: 'must be array' })
      end

      it "given items_attributes without quantity attribute" do
        result = described_class.call(@invalid_3)
        expect(result).to be_a_failure
        expect(result.errors).to eq({ items_attributes: 'objects in array must have quantity and id' })
      end

      it "given invalid item id" do
        result = described_class.call(@invalid_4)
        expect(result).to be_a_failure
        expect(result.errors).to eq({ items_attributes: 'item with id 9999 not found' })
      end
    end

    describe ".call" do
      before(:each) {
        @item = create(:item)
        @valid = {
          name: 'Joel',
          gender: 'male',
          age: 44,
          last_location_attributes: { lat: 123.21, lng: 123.21 },
          items_attributes: [{ id: @item.id, quantity: 3 }]
        }
      }

      it "given valid attributes" do
        result = described_class.call(@valid)
        expect(result).to be_a_success
      end
    end
  end
end