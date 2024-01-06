# frozen_string_literal: true

RSpec.describe RubocopAnalysis::Cops::Base do
  describe "#initialize" do
    let(:data) do
      {
        "severity" => "convention",
        "message" => "Metrics/MethodLength: Method has too many lines. [21/10]",
        "cop_name" => "Metrics/MethodLength",
        "corrected" => false,
        "correctable" => false,
        "location" => {
          "start_line" => 43, "start_column" => 3, "last_line" => 68, "last_column" => 5, "length" => 859, "line" => 43,
          "column" => 3
        }
      }
    end

    it "initializes an object with all keys" do
      base = RubocopAnalysis::Cops::Base.new(**data.transform_keys { _1.to_sym rescue key })
      aggregate_failures do
        expect(base.severity).to eq(data_symbols[:severity])
        expect(base.message).to eq(data_symbols[:message])
        expect(base.cop_name).to eq(data_symbols[:cop_name])
        expect(base.corrected).to eq(data_symbols[:corrected])
        expect(base.correctable).to eq(data_symbols[:correctable])
        expect(base.location).to eq(data_symbols[:location])
      end
    end
  end
end
