class Pxeger
  class Tree < Array
    attr_accessor :num

    def depth
      return @depth if @depth
      return @depth = 1 unless self.any? {|t| t.instance_of?(self.class)}
      @depth = self.pick.depth + 1
    end

    def pick
      return self.sample unless self.any? {|t| t.instance_of?(self.class)}

      child_trees = self.select {|c| c.instance_of?(self.class)}

      max = child_trees.max do |a, b|
        a.depth <=> b.depth
      end

      Tree.new(child_trees.select {|t| t.depth == max.depth}.sample)
    end
  end
end
