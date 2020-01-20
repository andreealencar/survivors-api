module Api::V1
  class ReportsController < ApplicationController
    # POST /reports/contamination
    def contamination
      @contamination_report = ContaminationReport.new(contamination_report_params)

      if @contamination_report.save
        render json: ContaminationReportBlueprint.render(@contamination_report), status: :created
      else
        render json: @contamination_report.errors, status: :unprocessable_entity
      end
    end

    # GET /reports/infected_percentage
    def infected_percentage
      render json: { percentage: get_infected_percentage }, status: :ok
    end

    # GET /reports/not_infected_percentage
    def not_infected_percentage
      render json: { percentage: get_not_infected_percentage }, status: :ok
    end

    # GET /reports/lost_points
    def lost_points
      render json: { lost_points: get_lost_points }, status: :ok
    end

    # GET /reports/average_amount_items
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
