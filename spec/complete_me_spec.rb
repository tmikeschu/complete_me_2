require "complete_me"

RSpec.describe CompleteMe do
  describe "attributes" do
    it "has a root node" do
      expect(subject.root).to be_a Node
    end
  end

  describe "#suggest" do
    it "returns possible completions for an input" do
      %w(apple carrot app careless).each { |w| subject.insert(w) }
      expect(subject.suggest("ap")).to match_array %w(apple app)
    end

    it "returns possible completions for a different input" do
      %w(apple carrot app careless).each { |w| subject.insert(w) }
      expect(subject.suggest("ca")).to match_array %w(carrot careless)
    end

    it "returns possible completions for another input" do
      %w(apple carrot app careless).each { |w| subject.insert(w) }
      expect(subject.suggest("care")).to match_array %w(careless)
    end

    it "returns all possible words with no input" do
      words = %w(apple carrot app careless)
      words.each { |w| subject.insert(w) }
      expect(subject.suggest).to match_array words
    end

    it "returns empty array for no matches" do
      %w(apple carrot app careless).each { |w| subject.insert(w) }
      expect(subject.suggest("z")).to match_array []
    end
  end
end
