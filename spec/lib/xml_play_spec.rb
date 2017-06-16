require_relative "../spec_helper"

describe XmlPlay do
  let(:xml) do
    Nokogiri::XML(<<-PLAY.strip
    <ACT><TITLE>ACT I</TITLE>
    <SCENE><TITLE>SCENE I</TITLE>
    <SPEECH>
    <SPEAKER>First Witch</SPEAKER>
    <LINE>When shall we three meet again</LINE>
    <LINE>In thunder, lightning, or in rain?</LINE>
    </SPEECH>

    <SPEECH>
    <SPEAKER>Second Witch</SPEAKER>
    <LINE>When the hurlyburly's done,</LINE>
    <LINE>When the battle's lost and won.</LINE>
    </SPEECH>

    <SPEECH>
    <SPEAKER>Third Witch</SPEAKER>
    <LINE>That will be ere the set of sun.</LINE>
    </SPEECH>

    <SPEECH>
    <SPEAKER>First Witch</SPEAKER>
    <LINE>Where the place?</LINE>
    </SPEECH>
    </SCENE>
    </ACT>
    PLAY
    )
  end
  let(:speech_node) do
    Nokogiri::XML(<<-NODE.strip
    <SPEECH>
    <SPEAKER>Second Witch</SPEAKER>
    <LINE>When the hurlyburly's done,</LINE>
    <LINE>When the battle's lost and won.</LINE>
    </SPEECH>
    NODE
    ).xpath("//SPEECH")
  end
  let(:scene) { XmlPlay.new(xml) }

  describe "#speakers_line_map" do
    context "no args passed" do
      let(:expected_map) do
        {
          "First Witch" => 3,
          "Second Witch" => 2,
          "Third Witch" => 1,
        }
      end
      it "builds a map of speaker to line count for each speaker" do
        expect(scene.speakers_line_map).to eq(expected_map)
      end
    end
    context "only option passed" do
      let(:expected_map) { { "Second Witch" => 2 } }
      it "builds a speaker to line count for only those speakers" do
        expect(scene.speakers_line_map(only: ["Second Witch"])).to eq(expected_map)
      end
    end
    context "exclude option passed" do
      let(:expected_map) { { "First Witch" => 3, "Third Witch" => 1 } }
      it "builds a speaker to line count map, excluding those speakers" do
        expect(scene.speakers_line_map(exclude: ["Second Witch"])).to eq(expected_map)
      end
    end
  end

  describe "#extract_lines_from" do
    it "finds all the lines within a speech node" do
      expect(scene.extract_lines_from(speech_node).map(&:name).uniq).to match(["LINE"])
      expect(scene.extract_lines_from(speech_node).count).to eq(2)
    end
  end

  describe "#extract_speaker_from" do
    it "finds the speaker within a speech node" do
      expect(scene.extract_speaker_from(speech_node)).to eq("Second Witch")
    end
  end

  describe "#init_speaker_line_map" do
    let(:speaker_map) { scene.init_speaker_line_map(scene.extract_speakers) }
    let(:expected_map) do
      {
        "First Witch" => 0,
        "Second Witch" => 0,
        "Third Witch" => 0,
      }
    end
    it "builds a new hash where each key is a speaker with a 0 value" do
      expect(speaker_map).to eq(expected_map)
    end
  end

  describe "#extract_speakers" do
    context "when no args provided" do
      let(:expected_speakers) { ["First Witch", "Second Witch", "Third Witch"] }

      it "will provide a list of the speaker in the play" do
        expect(scene.extract_speakers).to match(expected_speakers)
      end
    end
    context "when only option passed" do
      let(:expected_speakers) { ["Second Witch"] }

      it "will only provide those speakers" do
        expect(scene.extract_speakers(only: ["Second Witch"])).to match(expected_speakers)
      end
    end
    context "when exclude option passed" do
      let(:expected_speakers) { ["First Witch", "Third Witch"] }

      it "will exclude those speakers" do
        expect(scene.extract_speakers(exclude: ["Second Witch"])).to match(expected_speakers)
      end
    end
  end
end
