require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "private methods" do
    let(:employee) do
      described_class.new(
        first_name: "  jean  ",
        last_name: " dupont ",
        email: " DUPONT@email.COM ",
        employee_hr_id: " HR123 "
      )
    end

    describe "#sanitize_fields" do
      it "cleans and formats fields correctly" do
        employee.send(:sanitize_fields)

        expect(employee.first_name).to eq("Jean")
        expect(employee.last_name).to eq("DUPONT")
        expect(employee.email).to eq("dupont@email.com")
        expect(employee.employee_hr_id).to eq("HR123")
      end

      it "does nothing if fields are nil" do
        employee.first_name = nil
        employee.last_name = nil
        employee.email = nil
        employee.employee_hr_id = nil

        expect { employee.send(:sanitize_fields) }.not_to raise_error
      end
    end

    describe "#set_hr_id" do
      it "generates a unique employee_hr_id if not present" do
        employee.employee_hr_id = nil
        allow(SecureRandom).to receive(:hex).and_return("abc123")

        employee.send(:set_hr_id)

        expect(employee.employee_hr_id).to eq("HRABC123")
      end

      it "does not overwrite an existing employee_hr_id" do
        original_id = employee.employee_hr_id
        employee.send(:set_hr_id)
        expect(employee.employee_hr_id).to eq(original_id)
      end
    end
  end
end
