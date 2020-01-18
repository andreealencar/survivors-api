require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  describe "associations" do
    it { should belong_to(:item) }
    it { should belong_to(:survivor) }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
  end
end
