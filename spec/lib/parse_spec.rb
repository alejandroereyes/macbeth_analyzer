require_relative "../spec_helper"

describe Parse do
  let(:parser) { Object.new.extend Parse }

  describe "#total_lines_for_character" do
    let(:this_string) do
      "ACT I

SCENE I. A desert place.



    Thunder and lightning. Enter three Witches



First Witch



    When shall we three meet again

    In thunder, lightning, or in rain?



Second Witch



    When the hurlyburly's done,

    When the battle's lost and won.



Third Witch



    That will be ere the set of sun.



"
    end

    context "when character has 0 lines" do
      let(:subject) { parser.total_lines_for_character("MACBETH", this_string) }

      it { is_expected.to eq(0) }
    end
    context "when character only has 1 line" do
      let(:subject) { parser.total_lines_for_character("Third Witch", this_string) }

      it { is_expected.to eq(1) }
    end
    context "when character has more than 1 line" do
      let(:subject) { parser.total_lines_for_character("First Witch", this_string) }

      it { is_expected.to eq(2) }
      it { is_expected.not_to eq(4) }
    end
  end

  describe "#character_name?" do
    let(:new_section_identifiers) { Parse::NEW_SECTION_IDENTIFIERS }
    let(:subject) { parser.character_name?(this_string) }

    context "when only character is a newline" do
      let(:this_string) { "\n" }

      it { is_expected.to be false }
    end
    context "when first character is empty space" do
      let(:this_string) { " first character is empty space" }

      it { is_expected.to be false }
    end
    context "when first character is alpha_numeric and word is a new section identifier" do
      let(:this_string) { new_section_identifiers.sample.upcase }

      it { is_expected.to be false }
    end
    context "when first character is alpha_numeric and word is not a new section identifier" do
      let(:this_string) { "First Witch" }

      it { is_expected.to be true }
    end
  end

  describe "#spoken_line?" do
    let(:subject) { parser.spoken_line?(this_string) }

    context "when string is a new section identifier" do
      let(:this_string) { "ACT I" }

      it { is_expected.to be false }
    end
    context "when string is a character name" do
      let(:this_string) { "First Witch" }

      it { is_expected.to be false }
    end
    context "when string only contains whitespace characters" do
      let(:this_string) { "\n\n" }

      it { is_expected.to be false }
    end
    context "when string is empty" do
      let(:this_string) { "" }

      it { is_expected.to be false }
    end
    context "when string" do
      let(:this_string) { "    How far is't call'd to Forres? What are these" }

      it { is_expected.to be true }
    end
  end

  describe "#normalize" do
    let(:expected_string) { "One Two" }
    let(:subject) { parser.normalize(this_string) }

    context "when string has underscores" do
      let(:this_string) { "_One_Two_" }

      it { is_expected.to eq(expected_string) }
    end
    context "when string has spaces" do
      let(:this_string) { "One Two" }

      it { is_expected.to eq(expected_string) }
    end
    context "when first letter is not capitalized" do
      let(:this_string) { "one two" }

      it { is_expected.to eq(expected_string) }
    end
    context "when non first letters are capitalized" do
      let(:this_string) { "ONE tWO" }

      it { is_expected.to eq(expected_string) }
    end
  end
end
