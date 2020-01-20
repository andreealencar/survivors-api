class Survivor < ApplicationRecord
  #== ASSOCIATIONS =========================================
  has_one :last_location, class_name: "Location", foreign_key: :survivor_id
  has_many :inventory_items
  has_many :items, through: :inventory_items

  has_many :accusers, class_name: 'ContaminationReport', foreign_key: :suspect_id
  has_many :suspects, class_name: 'ContaminationReport', foreign_key: :accuser_id
  
  #== ACCEPTED ATTRIBUTES ==================================
  enum gender: { female: 'female', male: 'male' }
  accepts_nested_attributes_for :last_location

  #== VALIDATIONS ==========================================
  validates :name, uniqueness: true
  validates :name, :gender, :age, presence: true
end
