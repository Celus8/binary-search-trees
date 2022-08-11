class Node
  include Comparable
  attr_accessor :data, :left, :right

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

  def insert(value, node = @root)
    return if @array.include?(value)

    if value < node.data
      if node.left.nil? || node.left.data.nil?
        node.left = Node.new(value)
        @array.push(value)
      else
        insert(value, node.left)
      end
    else
      if node.right.nil? || node.right.data.nil?
        node.right = Node.new(value)
        @array.push(value)
      else
        insert(value, node.right)
      end
    end
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
      queue.compact!
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

  def inorder(node = @root, values = [], &block)
    return node if node.nil?

    inorder(node.left, values, &block)
    block_given? ? block.call(node) : values.push(node.data)
    inorder(node.right, values, &block)
    return values unless block_given?
  end

  def preorder(node = @root, values = [], &block)
    return node if node.nil?

    block_given? ? block.call(node) : values.push(node.data)
    preorder(node.left, values, &block)
    preorder(node.right, values, &block)
    return values unless block_given?
  end

  def postorder(node = @root, values = [], &block)
    return node if node.nil?

    postorder(node.left, values, &block)
    postorder(node.right, values, &block)
    block_given? ? block.call(node) : values.push(node.data)
    return values unless block_given?
  end

  def height(node, counter = 0)
    if node.left.nil? && node.right.nil?
      counter
    elsif node.left.nil?
      height(node.right, counter + 1)
    elsif node.right.nil?
      height(node.left, counter + 1)
    else
      height(node.left, counter + 1) >= height(node.right, counter + 1) ? height(node.left, counter + 1) : height(node.right, counter + 1)
    end
  end

  def depth(node)
    height(@root) - height(node)
  end

  def balanced?
    @array.each do |value|
      next if find(value).left.nil? && find(value).right.nil?
      unless (height(find(value).left || find(value).right) - height(find(value).right || find(value).left)).between?(-1, 1)
        return false
      end
    end
    true
  end

  def rebalance
    build_tree(@array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

bst = Tree.new
bst.build_tree((Array.new(15) { rand(1..100) }))
puts bst.balanced?
print "Level order: #{bst.level_order}\n"
print "Inorder: #{bst.inorder}\n"
print "Preorder: #{bst.preorder}\n"
print "Postorder: #{bst.postorder}\n"
bst.insert(1)
bst.insert(101)
bst.insert(102)
bst.insert(103)
bst.insert(104)
bst.insert(105)
bst.insert(106)
bst.insert(107)
bst.insert(108)
bst.pretty_print
puts bst.balanced?
bst.rebalance
bst.pretty_print
print "Level order: #{bst.level_order}\n"
print "Inorder: #{bst.inorder}\n"
print "Preorder: #{bst.preorder}\n"
print "Postorder: #{bst.postorder}\n"
puts bst.balanced?
