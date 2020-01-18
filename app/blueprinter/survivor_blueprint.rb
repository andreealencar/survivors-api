class SurvivorBlueprint < Blueprinter::Base
  #== IDENTIFIER =========================================
  identifier :id
  
  #== FIELDS =============================================
  fields :name, :gender, :age
  
  #== ASSOCIATIONS =======================================
  association :last_location, blueprint: LocationBlueprint
  association :inventory_items, blueprint: InventoryItemBlueprint
end