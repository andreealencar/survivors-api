require "rails_helper"

RSpec.describe Survivors::Trade, :type => :interactor do
  describe "validations" do
    before(:each) do
      @survivor_1 = create(:survivor)
      @survivor_2 = create(:survivor)

      @item_1 = create(:item, points: 4)
      @item_2 = create(:item, points: 2)

      InventoryItem.create([
        { survivor: @survivor_1, item: @item_1, quantity: 1 },
        { survivor: @survivor_2, item: @item_2, quantity: 2 }
      ])

      @valid = {
        survivor_1_id: @survivor_1.id,
        survivor_2_id: @survivor_2.id,
        survivor_1_items: [ { item_id: @item_1.id, quantity: 1 } ],
        survivor_2_items: [ { item_id: @item_2.id, quantity: 2 } ]
      }
    end

    it "given invalid params format" do
      invalid = @valid.merge({ survivor_1_id: 'invalid' })
      result  = described_class.call(invalid)

      expect(result).to be_a_failure
      expect(result.errors).to eq({ params: 'invalid params format' })
    end
    
    it "given survivor_id don't exists" do
      invalid = @valid.dup
      invalid[:survivor_1_id] = 9999

      result = described_class.call(invalid)

      expect(result).to be_a_failure
      expect(result.errors).to eq({ survivor_1_id: 'not found' })
    end

    it "given item isn\'t in survivor inventory" do
      invalid = @valid.dup
      invalid[:survivor_1_items][0][:item_id] = create(:item).id

      result = described_class.call(invalid)

      expect(result).to be_a_failure
      expect(result.errors).to eq({ survivor_1_items: 'haven\'t item in inventory' })
    end

    it "given item isn\'t in survivor inventory" do
      invalid = @valid.dup
      invalid[:survivor_2_items][0][:quantity] = 9999
      result = described_class.call(invalid)

      expect(result).to be_a_failure
      expect(result.errors).to eq({ survivor_2_items: 'haven\'t item quantity in inventory' })
    end

    it "given items with different points values" do
      rare_item = create(:item, points: 9999)
      InventoryItem.create(survivor: @survivor_1, item: rare_item, quantity: 1)

      invalid = @valid.dup
      invalid[:survivor_1_items][0][:item_id] = rare_item.id
      result = described_class.call(invalid)

      expect(result).to be_a_failure
      expect(result.errors).to eq({ points: 'total points must be equal in trade' })
    end
  end

  describe ".call" do
    before(:each) do
      @survivor_1 = create(:survivor)
      @survivor_2 = create(:survivor)

      @item_1 = create(:item, points: 4)
      @item_2 = create(:item, points: 2)

      InventoryItem.create([
        { survivor: @survivor_1, item: @item_1, quantity: 1 },
        { survivor: @survivor_2, item: @item_2, quantity: 2 }
      ])

      @valid = {
        survivor_1_id: @survivor_1.id,
        survivor_2_id: @survivor_2.id,
        survivor_1_items: [ { item_id: @item_1.id, quantity: 1 } ],
        survivor_2_items: [ { item_id: @item_2.id, quantity: 2 } ]
      }
    end

    it "given valid attributes" do
      result = described_class.call(@valid)
      expect(result).to be_a_success
    end
  end
end