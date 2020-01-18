require 'rails_helper'

RSpec.describe Survivor, type: :model do
  describe "associations" do
    it { should have_one(:last_location).class_name('Location').with_foreign_key(:survivor_id) }
    it { should have_many(:inventory_items) }
    it { should have_many(:items).through(:inventory_items) }
  end

  describe "accepted attributes" do
    it do
      should define_enum_for(:gender)
        .with_values(female: 'female', male: 'male')
        .backed_by_column_of_type(:string)
    end
    it { should accept_nested_attributes_for(:last_location) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:gender) }

    it { should validate_uniqueness_of(:name) }
  end
end
