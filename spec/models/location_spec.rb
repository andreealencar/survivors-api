require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'associations' do
    it { should belong_to(:survivor).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lng) }
  end
end
