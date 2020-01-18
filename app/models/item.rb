class Item < ApplicationRecord
  #== ASSOCIATIONS =========================================
  has_many :inventory_items
  has_many :survivors, through: :inventory_items

  #== VALIDATIONS ==========================================
  validates :name, uniqueness: true
  validates :name, :points, presence: true
end
