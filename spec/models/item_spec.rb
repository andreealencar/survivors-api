require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should have_many(:inventory_items) }
    it { should have_many(:survivors).through(:inventory_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:points) }

    it { should validate_uniqueness_of(:name) }
  end
end
