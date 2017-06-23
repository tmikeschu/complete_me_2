require "node"

RSpec.describe Node do
  describe "attributes" do
    it "has links" do
      expect(subject).to respond_to(:links)
    end

    it "is not terminal at the root" do
      expect(subject.terminal).to eq false
    end
  end

  describe "#insert" do
    it "adds a single letter" do
      subject.insert("a")
      expect(subject.links["a"]).to be_a Node
      expect(subject.links["a"].terminal).to be true
    end

    it "adds a two letter word" do
      subject.insert("be")
      expect(subject.links.keys).to match_array ["b"]
      expect(subject.links["b"].terminal).to be false

      next_node = subject.links["b"]
      expect(next_node.links.keys).to match_array ["e"]
      expect(next_node.links["e"].terminal).to be true
    end

    it "adds a five letter word" do
      word = "train"
      subject.insert(word)
      node = subject
      5.times do |i|
        letter = word[i]
        expect(node.links.keys).to match_array [letter]
        expect(node.links[letter].terminal).to be (i == 4)
        node = node.links[letter]
      end
    end

    it "adds multiple words with different starting letters" do
      subject.insert("apple")
      subject.insert("carrot")
      expect(subject.links.keys).to match_array ["a", "c"]
      expect(subject.links["a"].links.keys).to match_array ["p"]
      expect(subject.links["c"].links.keys).to match_array ["a"]
    end

    it "adds two words with the same starting letters" do
      subject.insert("apple")
      subject.insert("argot")
      expect(subject.links.keys).to match_array ["a"]
      expect(subject.links["a"].links.keys).to match_array ["p", "r"]
    end

    it "converts middle words to terminal nodes" do
      subject.insert("apple")
      subject.insert("argot")
      second_p_node = subject.links["a"].links["p"].links["p"]
      expect(second_p_node.terminal).to be false

      subject.insert("app")
      expect(second_p_node.terminal).to be true
    end
  end

  describe "#word_count" do
    it "returns the number of words in the trie" do
      expect(subject.word_count).to eq 0
      subject.insert("apple")
      expect(subject.word_count).to eq 1
      subject.insert("argot")
      expect(subject.word_count).to eq 2
      subject.insert("app")
      expect(subject.word_count).to eq 3
      subject.insert("carrot")
      expect(subject.word_count).to eq 4
    end

    it "inserting the same word does not increment word count" do
      subject.insert("apple")
      expect(subject.word_count).to eq 1
      subject.insert("apple")
      expect(subject.word_count).to eq 1
    end
  end

  describe "#suggest" do
    it "returns possible completions for a node with one word" do
      subject.insert("apple")
      expect(subject.suggest).to match_array %w(apple)
    end

    it "returns possible completions for a node with two words" do
      subject.insert("apple")
      subject.insert("app")
      expect(subject.suggest).to match_array %w(apple app)
    end

    it "returns possible completions for two words with different roots" do
      subject.insert("apple")
      subject.insert("carrot")
      expect(subject.suggest).to match_array %w(apple carrot)
    end

    it "returns possible completions for a complex case" do
      words = %w(apple app carrot cart zenith)
      words.each { |word| subject.insert(word) }
      expect(subject.suggest).to match_array words
    end
  end
end
