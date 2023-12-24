INPUT_FILENAME = "day23-input.txt"

# Part One
class Day23Solver
  def initialize
    @nodes = {}

    File.open(INPUT_FILENAME).each_with_index do |row, y_index|
      row.strip.chars.each_with_index do |char, x_index|
        @nodes[[x_index, y_index]] = {
          char: char,
          neighbors: []
        }
      end
    end

    @max_y = @nodes.keys.map { |k| k[1] }.max
    @start_node = nil
    @end_node = nil
    @longest_path_size = 0

    @decision_nodes = []
    @contracted_graph = {}
  end

  def build_p1_graph
    @nodes.each do |node_coords, node_hash|
      next if node_hash[:char] == "#"

      @start_node = node_coords if node_hash[:char] == "." && node_coords[1] == 0
      @end_node = node_coords if node_hash[:char] == "." && node_coords[1] == @max_y

      [[1,0], [0,1], [-1,0], [0,-1]].each do |move|
        next if (node_hash[:char] == "^" && move != [0,-1])
        next if (node_hash[:char] == "v" && move != [0,1])
        next if (node_hash[:char] == "<" && move != [-1,0])
        next if (node_hash[:char] == ">" && move != [1,0])

        neighbor_coords = [node_coords, move].transpose.map(&:sum)

        if @nodes[neighbor_coords] && @nodes[neighbor_coords][:char] != "#" &&
            !(@nodes[neighbor_coords][:char] == "^" && move == [0,1]) &&
            !(@nodes[neighbor_coords][:char] == "v" && move == [0,-1]) &&
            !(@nodes[neighbor_coords][:char] == "<" && move == [1,0]) &&
            !(@nodes[neighbor_coords][:char] == ">" && move == [-1,0])

          node_hash[:neighbors] = node_hash[:neighbors].concat([neighbor_coords])
        end
      end
    end
  end

  def build_p2_graph
    @nodes.each do |node_coords, node_hash|
      next if node_hash[:char] == "#"

      @start_node = node_coords if node_hash[:char] == "." && node_coords[1] == 0
      @end_node = node_coords if node_hash[:char] == "." && node_coords[1] == @max_y

      [[1,0], [0,1], [-1,0], [0,-1]].each do |move|
        neighbor_coords = [node_coords, move].transpose.map(&:sum)

        if @nodes[neighbor_coords] && @nodes[neighbor_coords][:char] != "#"
          node_hash[:neighbors] = node_hash[:neighbors].concat([neighbor_coords])
        end
      end

      @decision_nodes << node_coords if node_hash[:neighbors].count > 2
    end

    @decision_nodes = @decision_nodes + [@start_node, @end_node]

    @decision_nodes.each do |node_coords|
      node_hash = @nodes[node_coords]

      node_hash[:neighbors].each do |neighbor|
        nodes_to_visit = [[neighbor, 1]]
        visited_nodes = [node_coords]

        while nodes_to_visit
          new_coords, path_length = nodes_to_visit.shift
          new_node_hash = @nodes[new_coords]

          break if visited_nodes.include?(new_coords)

          visited_nodes << new_coords

          if path_length > 0 && @decision_nodes.include?(new_coords)
            @contracted_graph[node_coords] ||= {}
            @contracted_graph[node_coords].merge!({
              new_coords => path_length
            })

            @contracted_graph[new_coords] ||= {}
            @contracted_graph[new_coords].merge!({
              node_coords => path_length
            })
            break
          end

          neighbors = new_node_hash[:neighbors] - visited_nodes

          neighbors.each do |neighbor|
            nodes_to_visit.push([neighbor, path_length + 1])
          end
        end
      end
    end
  end

  def traverse(node, current_path)
    return if current_path.include?(node)

    current_path = current_path.dup
    current_path << node

    if node == @end_node
      @longest_path_size = [
        @longest_path_size,
        current_path.sum { |coords| @nodes[coords][:path_length] || 1 }
      ].max
      return
    end

    @nodes[node][:neighbors].each do |next_neighbor|
      traverse(next_neighbor, current_path)
    end
  end

  def traverse_contracted(coords, current_path, current_length)
    return if current_path.include?(coords)

    current_path = current_path.dup
    current_path << coords

    if coords == @end_node
      @longest_path_size = [
        @longest_path_size,
        current_length
      ].max
      return
    end

    @contracted_graph[coords].each do |next_neighbor, path_length|
      traverse_contracted(next_neighbor, current_path, current_length + path_length)
    end
  end

  def solve_part_one
    build_p1_graph
    traverse(@start_node, [])
    puts @longest_path_size - 1
  end

  def solve_part_two
    @contracted_graph = {}
    @nodes.each do |node_coords, node_hash|
      node_hash[:char] = node_hash[:char].gsub(/\<|\>|\^|v/,".")
    end
    build_p2_graph
    traverse_contracted(@start_node, [], 0)
    puts @longest_path_size
  end
end

Day23Solver.new.solve_part_one
Day23Solver.new.solve_part_two
