class Location < ApplicationRecord
  #== ASSOCIATIONS =========================================
  belongs_to :survivor, required: false

  #== VALIDATIONS ==========================================
  validates :lat, :lng, presence: true
end
