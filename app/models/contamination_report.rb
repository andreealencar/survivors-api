class ContaminationReport < ApplicationRecord
  #== ASSOCIATIONS =========================================
  belongs_to :accuser, class_name: 'Survivor'
  belongs_to :suspect, class_name: 'Survivor'

  #== VALIDATIONS ==========================================
  validates :accuser, :suspect, presence: true
  validates :suspect, uniqueness: { scope: :accuser_id }

  validate :accusations_count
  
  #== CALLBACKS ============================================
  after_save :update_survivor

  def accusations_count
    total_accusations = suspect&.accusers&.count || 0
    if total_accusations > 2
      errors.add(:suspect, "have 3 accuations limit")
    end
  end

  def update_survivor
    total_accusations = suspect&.accusers&.count || 0
    if total_accusations > 2
      suspect.update(infected: true)
    end
  end
end
