module Api::V1
  class ReportsController < ApplicationController
    def_param_group :percentage do
      property :percentage, Float
    end

    def_param_group :lost_points do
      property :lost_points, Integer
    end

    def_param_group :average_by_item do
      property :average_by_item, Hash
    end

    def_param_group :contamination_report_params do
      param :contamination_report, Hash do
        param :accuser_id, Integer
        param :suspect_id, Integer
      end
    end

    def_param_group :contamination_report_response do
      property :accuser, Hash do
        property :id, Integer
        property :name, String
        property :gender, String
        property :age, Integer
        property :last_location, Hash do
          property :lat, Float
          property :lng, Float
        end
        property :inventory_items, Array, of: Hash do
          property :quantity, Integer
          property :item, Hash do
            property :name, String
            property :points, Integer
          end
        end
      end
      property :suspect, Hash do
        property :id, Integer
        property :name, String
        property :gender, String
        property :age, Integer
        property :last_location, Hash do
          property :lat, Float
          property :lng, Float
        end
        property :inventory_items, Array, of: Hash do
          property :quantity, Integer
          property :item, Hash do
            property :name, String
            property :points, Integer
          end
        end
      end
    end

    api :POST, '/reports/contamination'
    param_group :contamination_report_params
    returns :contamination_report_response, :desc => "Returns a contamination report (accuser and suspect survivors)"
    def contamination
      @contamination_report = ContaminationReport.new(contamination_report_params)

      if @contamination_report.save
        render json: ContaminationReportBlueprint.render(@contamination_report), status: :created
      else
        render json: @contamination_report.errors, status: :unprocessable_entity
      end
    end

    api :GET, '/reports/infected_percentage'
    returns :percentage, :desc => "Returns a percentage of infected survivors"
    def infected_percentage
      render json: { percentage: get_infected_percentage }, status: :ok
    end

    api :GET, '/reports/not_infected_percentage'
    returns :percentage, :desc => "Returns a percentage of not infected survivors"
    def not_infected_percentage
      render json: { percentage: get_not_infected_percentage }, status: :ok
    end

    api :GET, '/reports/lost_points'
    returns :lost_points, :desc => "Returns the total lost points by enfection"
    def lost_points
      render json: { lost_points: get_lost_points }, status: :ok
    end

    api :GET, '/reports/average_amount_items'
    returns :average_by_item, :desc => "Returns avarage of items by survivors not infecteds"
    def average_amount_items
      render json: { average_by_item: get_average_amounts }, status: :ok
    end

    private

    def contamination_report_params
      params.require(:contamination_report).permit(:accuser_id, :suspect_id)
    end

    def get_infected_percentage
      survivors = Survivor.all
      infecteds = survivors.select { |survivor| survivor.infected }

      infecteds.empty? ? 0.0 : (infecteds.count * 100.0) / survivors.count
    end

    def get_not_infected_percentage
      100.0 - get_infected_percentage
    end

    def get_lost_points
      infected_survivors = Survivor.all.select { |survivor| survivor.infected }

      infected_items = InventoryItem.where(survivor_id: infected_survivors.pluck(:id))

      infected_items.sum { |inventory_item|
        inventory_item.item.points * inventory_item.quantity 
      }
    end

    def get_average_amounts
      result = {}
      grouped_items = InventoryItem.all.group_by { |item| item.item.name }

      grouped_items.each { |name, inventory_items|
        result[name] = get_average_of_items(inventory_items)
      }

      result
    end

    def get_average_of_items(inventory_items)
      valid_survivors_count = Survivor.where(infected: false).count
      avarage = inventory_items.sum { |inventory_item| inventory_item.quantity } / valid_survivors_count.to_f
      avarage.round(2)
    end
  end
end
