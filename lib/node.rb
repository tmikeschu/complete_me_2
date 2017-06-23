class Node
  attr_reader :links, :terminal

  def initialize(terminal = false)
    @links = {}
    @terminal = terminal
  end

  def insert(raw)
    insert_options[raw.empty?].call(raw)
  end

  def terminal_node
    -> raw do
      @terminal = true
      self
    end
  end

  def next_node
    -> raw do
      char = raw[0].to_s
      @links[char] ||= Node.new
      @links[char].insert(raw[1..-1])
    end
  end

  def word_count
    ((@terminal && 1) || 0) + links.values.sum { |node| node.word_count }
  end

  def suggest(data = "")
    words = []
    terminal && words.push(data)
    words + links.flat_map { |letter, node| node.suggest(data + letter) }
  end

  private

  def insert_options
    {
      true => terminal_node,
      false => next_node
    }
  end
  
  def links?
    {
      true => count_words,
      false => no_links
    }
  end
end
