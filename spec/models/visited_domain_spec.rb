require 'rails_helper'

RSpec.describe VisitedDomain do
  describe "add_list" do
    context "placing data for the first time" do
      result = described_class.add_list( 900, %w[abc.com def.com www.klm.org xyz.me])

      it "returns not nil" do
        expect(result).not_to be_nil
      end
      it "returns correct number of items inserted - 4" do
        expect(result).to eq(4)
      end
    end

    context "placing data for the second time" do
      result = described_class.add_list( 900, %w[abc.com def.com xyz.me])
      it "returns not nil" do
        expect(result).not_to be_nil
      end
      it "returns correct number of items inserted - 0" do
        expect(result).to eq(0)
      end
    end

    context "placing data for the third time (with one new record)" do
      result = described_class.add_list( 900, %w[abc.com test.ru def.com xyz.me])
      it "returns not nil" do
        expect(result).not_to be_nil
      end
      it "returns correct number of items inserted - 1" do
        expect(result).to eq(1)
      end
    end

    context "Calling a method with parameters of the wrong type" do
      it "returns an exception for 'timestamp'" do
        expect { described_class.show('a', []) }.to raise_error(ArgumentError)
      end
      it "returns an exception for 'domains'" do
        expect { described_class.show(1, { a: 123 }) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "show" do
    context "An empty key (1000)" do
      it "contains nothing" do
        result = described_class.show(1000,1000)
        expect(result).to match_array([])
      end
    end

    context "After filling in the data. The query for the key (1000)" do
      described_class.add_list(1000, %w[test.ru])
      result = described_class.show(1000,1000)

      it "returns array" do
        expect(result).to be_a_kind_of(Array)
      end
      it "with exactly the same entry that was inserted" do
        expect(result).to contain_exactly('test.ru')
      end
    end

    context "An empty key (1001)" do
      it "contains nothing" do
        result = described_class.show(1001,1001)
        expect(result).to match_array([])
      end
    end

    context "After filling in the data. The query for the key (1001)" do
      described_class.add_list(1001, %w[best.com])
      result = described_class.show(1001,1001)

      it "with exactly the same entry that was inserted" do
        expect(result).to contain_exactly('best.com')
      end
    end

    context "Data in the interval (1000,1001)" do
      result = described_class.show(1000,1001)

      it "returns array" do
        expect(result).to be_a_kind_of(Array)
      end
      it "with exactly the same entries that were inserted" do
        expect(result).to contain_exactly('test.ru', 'best.com')
      end
    end

    context "Calling a method with parameters of the wrong type" do
      it "returns an exception" do
        expect { described_class.show('a', 'b') }.to raise_error(ArgumentError)
      end
    end
  end

  # Is it integration test?
  describe "add_list + show" do
    context "Uploading duplicate elements" do
      described_class.add_list(2000, %w[a1.com a2.com a3.com a1.com a2.com a4.com])
      result = described_class.show(2000,2000)
      it "leads to the downloading of unique" do
        expect(result.count).to eq(4)
        expect(result).to contain_exactly('a1.com', 'a2.com', 'a3.com', 'a4.com')
      end
    end
  end
end