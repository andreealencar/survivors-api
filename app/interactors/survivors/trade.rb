require "json-schema"

module Survivors
  class Trade < ApplicationInteractor

    #== VALIDATIONS =========================================
    before :params_format, :survivors_existence, :items_existence, :trade_value
    
    def call
      survivor_1 = Survivor.find(context[:survivor_1_id])
      survivor_2 = Survivor.find(context[:survivor_2_id])

      survivor_1_items = context[:survivor_1_items]
      survivor_2_items = context[:survivor_2_items]

      remove_inventory_items_of(survivor_1, survivor_1_items)
      remove_inventory_items_of(survivor_2, survivor_2_items)

      insert_inventory_items_of(survivor_1, survivor_2_items)
      insert_inventory_items_of(survivor_2, survivor_1_items)
    end

    private

    #== VALIDATIONS =========================================    
    def params_format
      schema = {
        type: "object",
        properties: {
          survivor_1_id: { type: "integer" },
          survivor_2_id: { type: "integer" },
          survivor_1_items: {
            type: "array",
            items: {
              type: "object",
              properties: {
                item_id: { type: "integer" },
                quantity: { type: "integer" },
              }
            }
          },
          survivor_2_items: {
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

    def survivors_existence
      survivor_1_id = context[:survivor_1_id]
      survivor_2_id = context[:survivor_2_id]

      context.fail!(errors: { survivor_1_id: 'not found' }) unless Survivor.exists?(survivor_1_id)
      context.fail!(errors: { survivor_2_id: 'not found' }) unless Survivor.exists?(survivor_2_id)
    end

    def items_existence
      survivor_1_id = context[:survivor_1_id]
      survivor_2_id = context[:survivor_2_id]
      survivor_1_items = context[:survivor_1_items]
      survivor_2_items = context[:survivor_2_items]

      context.fail!(errors: { survivor_1_items: 'haven\'t item in inventory' }) if has_invalid_item?(survivor_1_items, survivor_1_id)
      context.fail!(errors: { survivor_2_items: 'haven\'t item in inventory' }) if has_invalid_item?(survivor_2_items, survivor_2_id)

      if has_invalid_quantity_in?(survivor_1_items, survivor_1_id)
        context.fail!(errors: { survivor_1_items: 'haven\'t item quantity in inventory' })
      end

      if has_invalid_quantity_in?(survivor_2_items, survivor_2_id)
        context.fail!(errors: { survivor_2_items: 'haven\'t item quantity in inventory' })
      end
    end

    def has_invalid_item?(survivor_items, survivor_id)
      survivor_items.any? { |item|
        InventoryItem.ransack({
          survivor_id_eq: survivor_id,
          item_id_eq: item[:item_id],
        }).result.empty?
      }
    end

    def has_invalid_quantity_in?(survivor_items, survivor_id)
      survivor_items.any? { |item|
        InventoryItem.ransack({
          survivor_id_eq: survivor_id,
          item_id_eq: item[:item_id],
          quantity_lt: item[:quantity],
        }).result.present?
      }
    end

    def trade_value
      survivor_1_value = sum_points_from(context[:survivor_1_items])
      survivor_2_value = sum_points_from(context[:survivor_2_items])

      context.fail!(errors: { points: 'total points must be equal in trade' }) unless survivor_1_value == survivor_2_value
    end

    def sum_points_from(items)
      items.sum { |survivor_item|
        item = Item.find(survivor_item[:item_id])
        item.points * survivor_item[:quantity]
      }
    end

    #== AUX METHODS =========================================

    def remove_inventory_items_of(survivor, inventory_items)
      inventory_items.each { |inventory_item|
        item = InventoryItem.find_by(survivor: survivor, item_id: inventory_item[:item_id])
        item.quantity = item.quantity - inventory_item[:quantity]
        item.quantity == 0 ? item.destroy : item.save
      }
    end

    def insert_inventory_items_of(survivor, inventory_items)
      inventory_items.each { |inventory_item|
        item = InventoryItem.find_or_initialize_by(survivor: survivor, item_id: inventory_item[:item_id])
        item.quantity = item.new_record? ? inventory_item[:quantity] : item.quantity + inventory_item[:quantity]
        item.save
      }
    end

  end
end