class InventoryItem < ApplicationRecord
  #== ASSOCIATIONS =========================================
  belongs_to :survivor
  belongs_to :item
  
  #== VALIDATIONS ==========================================
  validates :quantity, presence: true
end
