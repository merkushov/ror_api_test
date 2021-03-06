require 'rails_helper'

RSpec.describe VisitedDomain do
  let(:test_fixtures) { yaml_fixture_file("links.yml") }

  describe "add_list" do
    subject(:add_uniq_1) { described_class.add_list(key, uniq_domains_1) }
    subject(:add_uniq_2) { described_class.add_list(key, uniq_domains_2) }

    let(:key)                 { 900 }
    let(:uniq_domains_1)      { test_fixtures["set_1"]["unique_domains"] }
    let(:uniq_domains_2)      { test_fixtures["set_2"]["unique_domains"] }

    context "placing data for the first time" do
      it "returns correct number of items inserted" do
        expect(add_uniq_1).to eq(uniq_domains_1.length)
      end
    end

    context "placing data for the second time" do
      it "returns correct number of items inserted - 0" do
        expect(add_uniq_1).to eq(0)
      end
    end

    context "placing data for the third time (with some new record)" do
      it "returns correct number of items inserted" do
        expect(add_uniq_2).to be > 0
      end
    end

    context "Calling a method with parameters of the wrong type" do
      let(:key) { 'a' }
      let(:uniq_domains_1) {[]}

      it "returns an exception for 'timestamp'" do
        expect { add_uniq_1 }.to raise_error(ArgumentError)
      end

      let(:key) { 1 }
      let(:uniq_domains_1) {{ a: 123 }}

      it "returns an exception for 'domains'" do
        expect { add_uniq_1 }.to raise_error(ArgumentError)
      end
    end
  end

  describe "show" do
    subject(:show) { described_class.show(interval[0], interval[1]) }
    subject(:show_after_add_1) do
      described_class.add_list(interval[0], uniq_domains_1)
      described_class.show(interval[0],interval[1])
    end
    subject(:show_after_add_2) do
      described_class.add_list(interval[0], uniq_domains_2)
      described_class.show(interval[0],interval[1])
    end
    let(:uniq_domains_1)    { test_fixtures["set_1"]["unique_domains"] }
    let(:uniq_domains_2)    { test_fixtures["set_2"]["unique_domains"] }
    let(:intersection_1_2)  { test_fixtures["intersection_1_2"]["unique_domains"] }

    context "An empty key (1000)" do
      let(:interval) { [1000,1000] }
      it "contains nothing" do
        expect(show).to match_array([])
      end
    end

    context "After filling in the data. The query for the key (1000)" do
      let(:interval) { [1000,1000] }
      it "with exactly the same entry that was inserted" do
        expect(show_after_add_1).to contain_exactly(*uniq_domains_1)
      end
    end

    context "An empty key (1001)" do
      let(:interval) { [1001,1001] }
      it "contains nothing" do
        expect(show).to match_array([])
      end
    end

    context "After filling in the data. The query for the key (1001)" do
      let(:interval) { [1001,1001] }

      it "with exactly the same entry that was inserted" do
        expect(show_after_add_2).to contain_exactly(*uniq_domains_2)
      end
    end

    context "Data in the interval (1000,1001)" do
      let(:interval) { [1000,1001] }

      it "with exactly the same entries that were inserted" do
        expect(show).to contain_exactly(*intersection_1_2)
      end
    end

    context "Calling a method with parameters of the wrong type" do
      let(:interval) { ['a','b'] }

      it "returns an exception" do
        expect { show }.to raise_error(ArgumentError)
      end
    end

    context "Calling a method with parameters of the correct type (numbers)" do
      let(:interval) { [1613997910,1613997920] }

      it "don't returns an exception for number" do
        expect( show ).to match_array([])
      end
    end

    context "Calling a method with parameters of the correct type (strings)" do
      let(:interval) { ["1613997910", "1613997920"] }

      it "don't returns an exception for string" do
        expect(show).to match_array([])
      end
    end
  end

  # Is it integration test?
  describe "add_list + show" do
    context "Uploading duplicate elements" do
      subject do
        described_class.add_list(2000, test_fixtures["set_2"]["domains"])
        described_class.show(2000,2000)
      end

      it "leads to the downloading of unique" do
        expect(subject).to contain_exactly(*test_fixtures["set_2"]["unique_domains"])
      end
    end
  end
end