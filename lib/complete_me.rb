require "node"

class CompleteMe
  attr_reader :root
  def initialize
    @root = Node.new
  end

  def insert(data)
    @root.insert(data)
  end

  def suggest(data = "", node = @root, link = 0)
    suggestion_start_traversed?(data, node, link)[data.length == link]
  end

  def cycle_node(data, node, link)
    next_node = node.links[data[link]]
    (next_node && suggest(data, next_node, link + 1)) ||
    []
  end

  private

  def suggestion_start_traversed?(data, node, link)
    {
      true  => node.suggest(data),
      false => cycle_node(data, node, link)
    }
  end
end
