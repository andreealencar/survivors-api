class Survivor < ApplicationRecord
  #== ASSOCIATIONS =========================================
  has_one :last_location, class_name: "Location", foreign_key: :survivor_id
  has_many :inventory_items
  has_many :items, through: :inventory_items
  
  #== ACCEPTED ATTRIBUTES ==================================
  enum gender: { female: 'female', male: 'male' }
  accepts_nested_attributes_for :last_location

  #== VALIDATIONS ==========================================
  validates :name, uniqueness: true
  validates :name, :gender, :age, presence: true
end
