module Api::V1
  class ContaminationReportsController < ApplicationController
    # POST /contamination_report/
    def create
      @contamination_report = ContaminationReport.new(contamination_report_params)

      if @contamination_report.save
        render json: ContaminationReportBlueprint.render(@contamination_report), status: :created
      else
        render json: @contamination_report.errors, status: :unprocessable_entity
      end
    end

    private

    def contamination_report_params
      params.require(:contamination_report).permit(:accuser_id, :suspect_id)
    end  
  end
end
