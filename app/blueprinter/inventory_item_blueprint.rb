class InventoryItemBlueprint < Blueprinter::Base  
  #== FIELDS =============================================
  fields :quantity

  #== ASSOCIATIONS =========================================
  association :item, blueprint: ItemBlueprint
end