module Survivors
  class Register < ApplicationInteractor

    #== VALIDATIONS =========================================
    before :params_format, :items_existence

    #== INVENTORY METHOD =========================================
    after :bind_items_to_survivors
    
    def call
      survivor = Survivor.new(context.to_h.except(:items_attributes))
      
      context.fail!(errors: survivor.errors.full_messages) unless survivor.save
      context.survivor = survivor
    end

    private

    #== VALIDATIONS =========================================
    def params_format
      schema = {
        type: "object",
        properties: {
          name: { type: "string" },
          age: { type: "integer" },
          gender: { type: "string" },
          last_location_attributes: {
            type: "object",
            properties: {
              lat: { type: "float" },
              lng: { type: "float" },
            }
          },
          items_attributes: {
            type: "array",
            items: {
              type: "object",
              properties: {
                item_id: { type: "integer" },
                quantity: { type: "integer" },
              }
            }
          }
        }
      }

      unless JSON::Validator.validate(schema, context.to_h, :strict => true)
        context.fail!(errors: { params: 'invalid params format' })
      end
    end

    def items_existence      
      invalid = context[:items_attributes].find { |item| !Item.exists?(item[:item_id]) }
      context.fail!(errors: { items_attributes: "item with id #{invalid[:item_id]} not found" }) if invalid.present?
    end

    #== INVENTORY METHOD =========================================
    def bind_items_to_survivors
      InventoryItem.create(context[:items_attributes].map { |item|
        { survivor_id: context.survivor.id, item_id: item[:item_id], quantity: item[:quantity] }
      })
    end

  end
end