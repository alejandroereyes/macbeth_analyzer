require_relative "../spec_helper"

describe Parse do
  let(:parser) { Object.new.extend Parse }

  describe "#normalize" do
    let(:expected_string) { "One Two" }

    shared_examples "normalized string equals expected string" do
      it "normalizes the string" do
        expect(parser.normalize(this_string)).to eq(expected_string)
      end
    end

    context "when string has underscores" do
      let(:this_string) { "_One_Two_" }

      include_examples "normalized string equals expected string"
    end
    context "when string has spaces" do
      let(:this_string) { "One Two" }

      include_examples "normalized string equals expected string"
    end
    context "when first letter is not capitalized" do
      let(:this_string) { "one two" }

      include_examples "normalized string equals expected string"
    end
    context "when non first letters are capitalized" do
      let(:this_string) { "ONE tWO" }

      include_examples "normalized string equals expected string"
    end
  end
end
