require 'rails_helper'

RSpec.describe ContaminationReport, type: :model do
  describe "associations" do
    it { should belong_to(:accuser).class_name("Survivor") }
    it { should belong_to(:suspect).class_name("Survivor") }
  end
  
  describe "validations" do
    subject { create(:contamination_report) }

    it { should validate_presence_of(:accuser) }
    it { should validate_presence_of(:suspect) }

    it { should validate_uniqueness_of(:suspect).scoped_to(:accuser_id) }

    describe "custom validations" do
      before(:each) do
        @survivor = create(:survivor)
        create_list(:contamination_report, 3, suspect: @survivor)
      end

      it "accusers limit" do
        contamination_report = ContaminationReport.new(accuser: create(:survivor), suspect: @survivor)
        expect(contamination_report.valid?).to eq(false)
        expect(contamination_report.errors.messages).to eq({ suspect: ["have 3 accuations limit"] })
      end
    end
  end
end
