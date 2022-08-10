class Node
  include Comparable
  attr_reader :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    @data <=> other.data
  end

  def to_s
    "(Data: #{@data}, left child: #{left}, right child: #{right})"
  end
end

class Tree
  def initialize(array = nil, root = nil)
    @array = array
    @root = root
  end

  def build_tree(array, start = 0, finish = nil)
    @array = array
    finish = array.length - 1 if finish.nil?
    return nil if start > finish || array.nil?

    array = array.uniq.sort
    mid = (start + finish) / 2
    left_tree = Tree.new(array[start..(mid - 1)]).build_tree(array, start, mid - 1)
    right_tree = Tree.new(array[(mid + 1)..]).build_tree(array, mid + 1, finish)
    @root = Node.new(array[mid], left_tree, right_tree)
  end

  def insert(value)
    @array.insert(1, value).sort
    build_tree(@array)
  end

  def delete(value)
    @array.delete(value)
    build_tree(@array)
  end

  def find(value)
    return unless @array.include?(value)

    queue = [@root]
    loop do
      node = queue[0]
      return node if node.data == value

      queue.shift
      next if node.left.nil? && node.right.nil?

      queue.push(node.left, node.right)
    end
  end

  def level_order
    queue = [@root]
    values = [] unless block_given?
    loop do
      node = queue[0]
      block_given? ? yield(node) : values.push(node.data)
      queue.shift
      queue.push(node.left, node.right)
      queue.compact!
      break if queue.empty?
    end
    return values unless block_given?
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

bst = Tree.new
bst.build_tree([1, 2, 3, 4, 5, 6, 7])
bst.insert(8)
bst.insert(10)
bst.delete(3)
bst.delete(5)
bst.pretty_print
bst.level_order { |node| puts "Data: #{node.data}" }
