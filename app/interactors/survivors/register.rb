module Survivors
  class Register < ApplicationInteractor

    #== VALIDATIONS =========================================
    before :location_validation, :items_validation, :items_existence

    #== INVENTORY METHOD =========================================
    after :bind_items_to_survivors
    
    def call
      survivor = Survivor.new(context.to_h.except(:items_attributes))
      
      context.fail!(errors: survivor.errors.full_messages) unless survivor.save
      context.survivor = survivor
    end

    private

    #== VALIDATIONS =========================================    
    def location_validation
      location = context[:last_location_attributes]

      context.fail!(errors: { last_location_attributes: 'is required' }) if location.nil? || location.empty?
      context.fail!(errors: { last_location_attributes: 'must be object' }) if location.is_a? Array

      unless location.values_at(:lat, :lng).all?
        context.fail!(errors: { last_location_attributes: 'must be object with values for lat and lng' })
      end
    end

    def items_validation
      items = context[:items_attributes]

      context.fail!(errors: { items_attributes: 'is required' }) if items.nil? || items.empty?
      context.fail!(errors: { items_attributes: 'must be array' }) unless items.is_a? Array

      unless items.all? { |item| item.values_at(:id, :quantity).all? }
        context.fail!(errors: { items_attributes: 'objects in array must have quantity and id' })
      end
    end

    def items_existence      
      invalid = context[:items_attributes].find { |item| !Item.exists?(item[:id]) }
      context.fail!(errors: { items_attributes: "item with id #{invalid[:id]} not found" }) if invalid.present?
    end

    #== INVENTORY METHOD =========================================
    def bind_items_to_survivors
      InventoryItem.create(context[:items_attributes].map { |item|
        { survivor_id: context.survivor.id, item_id: item[:id], quantity: item[:quantity] }
      })
    end

  end
end