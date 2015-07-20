require "pxeger/version"
require "pxeger/tree"
require "pxeger/constants"

class Pxeger
  def initialize(pattern)
    @pattern = pattern.instance_of?(Regexp) ? pattern.source : pattern
  end

  def generate
    @reference = {}
    tree = process_grouping(@pattern.chars)
    tree = process_select(tree)
    process_others(tree)
  end

  private

  def multi_backword_reference?
    return @is_multi_back_ref unless @is_multi_back_ref.nil?
    ref_indexes = @pattern.scan(/\\\d+/).map{|r| r.sub('\\','').to_i}
    @is_multi_back_ref = ref_indexes.any? {|i| i >= 2}
  end

  def process_grouping(pattern_array)
    tree  = Tree.new
    stack = Tree.new([tree])
    n = 1

    while (char = pattern_array.shift)
      if (char == "\\")
        next_char = pattern_array.shift
        if (%w| ( ) |.include?(next_char))
          stack[0].push(next_char)
        else
          stack[0].push(char, next_char)
        end
      elsif (char == '(')
        inner = Tree.new
        stack[0].push(inner)
        stack.unshift(inner)

        next_char = pattern_array.shift
        if (next_char == '?')
          next_char = pattern_array.shift
          if (next_char == ':')
            # nothing
          else
            raise "Invalid Group"
          end
        elsif (%w| ( ) |.include?(next_char))
          pattern_array.unshift(next_char)
        else
          inner.num = n
          n += 1
          inner.push(next_char)
        end
      elsif (char == ')')
        stack.shift
      else
        stack[0].push(char)
      end
    end

    return tree
  end

  def process_select(tree)
    candinates = Tree.new([Tree.new])

    while (char = tree.shift)
      if (char == '\\')
        next_char = tree.shift
        if (next_char == '|')
          candinates[0].push(next_char)
        else
          candinates[0].push(char, next_char)
        end
      elsif (char == '[')
        candinates[0].push(char)
        while (char = tree.shift)
          candinates[0].push(char)
          if (char == '\\')
            next_char = tree.shift
            candinates[0].push(next_char)
          elsif (char == ']')
            break
          end
        end
      elsif (char == '|')
        candinates.unshift(Tree.new)
      else
        candinates[0].push(char)
      end
    end

    candinates.each do |it|
      tree.push(it)
      len = it.length
      j = 0
      while ( j < len )
        process_select(it[j]) if it[j].instance_of?(Pxeger::Tree)
        j += 1
      end
    end

    return Tree.new([tree])
  end

  def process_others(tree)
    ret = ''
    candinates = Tree.new
    tree = tree.dup

    while (char = tree.shift)
      case char
      when '^'
      when '$'
      when '*'
        rand(10).times { ret << choose(candinates) }
        candinates = Tree.new
      when '+'
        (rand(10) + 1).times { ret << choose(candinates) }
        candinates = Tree.new
      when '{'
        brace = ''
        while (char = tree.shift)
          if (char == '}')
            break
          else
            brace << char
          end
        end

        if (char != '}')
          raise "missmatch brace: #{char}"
        end

        dd = brace.split(',')
        min = dd[0].to_i
        max = (dd.length == 1) ? min : (dd[1].to_i || 10)

        (rand(max - min + 1) + min).times { ret << choose(candinates) }
        candinates = Tree.new
      when '?'
        if rand(2) > 0
          ret << choose(candinates)
        end
        candinates = Tree.new
      when '\\'
        ret << choose(candinates)
        escaped = tree.shift

        if (escaped.match(/^[1-9]$/))
          candinates = [ @reference[escaped.to_i] || '' ]
        else
          if (%w(b B).include?(escaped))
            raise "\\b and \\B is not supported"
          end
          candinates = CLASSES[escaped]
        end

        unless candinates
          candinates = Tree.new([escaped])
        end
      when '['
        ret << choose(candinates)

        sets = Tree.new
        negative = false

        while (char = tree.shift)
          if (char == '\\')
            next_char = tree.shift
            if (CLASSES[next_char])
              sets = sets + CLASSES[next_char]
            else
              sets.push(next_char)
            end
          elsif (char == ']')
            break
          elsif (char == '^')
            before_char = sets.last
            if (!before_char)
              negative = true
            else
              sets.push(char)
            end
          elsif (char == '-')
            next_char = tree.shift
            if (next_char == ']')
              sets.push(char)
              char = next_char
              break
            end

            before_char = sets.last
            if (!before_char)
              sets.push(char)
            else
              ((before_char.ord + 1)...(next_char.ord)).each do |i|
                begin
                  sets.push(i.chr("UTF-8"))
                rescue RangeError => e
                  warn e if ENV["DEBUG"]
                end
              end
            end
          else
            sets.push(char)
          end
        end

        if (char != ']')
          raise "missmatch bracket: #{char}"
        end

        if (negative)
          neg = {}
          sets.each do |set|
            neg[set] = true
          end

          candinates = Tree.new
          ALL.each do |char|
            candinates.push(char) unless neg[char]
          end
        else
          candinates = sets
        end
      when '.'
        ret << choose(candinates)
        candinates = ALL
      else
        ret << choose(candinates)
        candinates = char
      end
    end

    return ret << choose(candinates)
  end

  def choose(candinates)
    candinates = candinates.dup
    candinates = candinates.chars if candinates.instance_of?(String)

    if candinates.instance_of?(Pxeger::Tree) && multi_backword_reference?
      ret = candinates.pick
    else
      ret = candinates.sample
    end

    if ((defined? ret) && ret.instance_of?(Pxeger::Tree))
      ret = process_others(ret)
    end

    if (candinates.respond_to?(:num) && candinates.num)
      @reference[candinates.num] = ret
    end

    return ret || ''
  end
end
