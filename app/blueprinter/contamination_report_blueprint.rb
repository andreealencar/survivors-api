class ContaminationReportBlueprint < Blueprinter::Base  
  #== ASSOCIATIONS =========================================
  association :accuser, blueprint: SurvivorBlueprint
  association :suspect, blueprint: SurvivorBlueprint
end