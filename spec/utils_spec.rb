require 'rails_helper'
require 'utils'

describe Utils do
  let(:test_fixtures) { yaml_fixture_file("links.yml") }

  describe ".convert_links_to_domains" do
    context "list of 3 regular links with different domains" do
      it "the result is an Array" do
        expect(
          Utils.convert_links_to_domains(test_fixtures["set_1"]["links"])
        ).to be_a_kind_of(Array)
      end
      it "returns a list of 3 different domains" do
        expect(
          Utils.convert_links_to_domains(test_fixtures["set_1"]["links"])
        ).to contain_exactly(*test_fixtures["set_1"]["unique_domains"])
      end
    end

    context "wrong argument type" do
      it "raise an exception" do
        expect {
          Utils.convert_links_to_domains("http://ya.ru/q=123")
        }.to raise_error(ArgumentError)
      end
    end

    context "there is a plain domain in the list" do
      it "converted successfully" do
        expect(
          Utils.convert_links_to_domains(test_fixtures["set_2"]["links"])
        ).to contain_exactly(*test_fixtures["set_2"]["domains"])
      end
    end

    context "There is a link in a subdomain" do
      it "converted successfully" do
        expect(
          Utils.convert_links_to_domains(test_fixtures["set_2"]["links"])
        ).to contain_exactly(*test_fixtures["set_2"]["domains"])
      end
    end
  end
end