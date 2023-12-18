INPUT_FILENAME = "day17-input.txt"

# Part One
class Day17Solver
  def initialize(range_min, range_max)
    nodes = {}

    File.open(INPUT_FILENAME).each_with_index do |row, y_index|
      row.strip.chars.each_with_index do |char, x_index|
        nodes[[x_index, y_index]] = char.to_i
      end
    end

    @max_x = nodes.keys.map { |k| k[0] }.max
    @max_y = nodes.keys.map { |k| k[1] }.max
    @start_node = [0, 0, "*"]

    @graph = build_graph(nodes, range_min, range_max)
    @best_distance = Float::INFINITY
  end

  def build_graph(nodes, range_min, range_max)
    graph = {}
    nodes.each do |node_coords, node_val|
      row = node_coords[0]
      col = node_coords[1]
      graph[[row, col, "V"]] = {
        least_distance: Float::INFINITY,
        neighbors: {}
      }
      graph[[row, col, "H"]] = {
        least_distance: Float::INFINITY,
        neighbors: {}
      }
        
      (range_min..range_max).each do |move_dist|
        # Up
        if nodes[[row, col + move_dist]]
          graph[[row, col, "V"]][:neighbors][[row, col + move_dist, "H"]] = 0
          (1..move_dist).each do |i|
            graph[[row, col, "V"]][:neighbors][[row, col + move_dist, "H"]] += nodes[[row, col + i]];
          end
        end

        # Down
        if nodes[[row, col - move_dist]]
          graph[[row, col, "V"]][:neighbors][[row, col - move_dist, "H"]] = 0
          (1..move_dist).each do |i|
            graph[[row, col, "V"]][:neighbors][[row, col - move_dist, "H"]] += nodes[[row, col - i]];
          end
        end

        # Right
        if nodes[[row + move_dist, col]]
          graph[[row, col, "H"]][:neighbors][[row + move_dist, col, "V"]] = 0
          (1..move_dist).each do |i|
            graph[[row, col, "H"]][:neighbors][[row + move_dist, col, "V"]] += nodes[[row + i, col]];
          end
        end

        # Left
        if nodes[[row - move_dist, col]]
          graph[[row, col, "H"]][:neighbors][[row - move_dist, col, "V"]] = 0
          (1..move_dist).each do |i|
            graph[[row, col, "H"]][:neighbors][[row - move_dist, col, "V"]] += nodes[[row - i, col]];
          end
        end
      end
    end

    graph[@start_node] = {
      least_distance: Float::INFINITY,
      neighbors: graph[[0, 0, "H"]][:neighbors].dup.merge(graph[[0, 0, "V"]][:neighbors].dup)
    }

    graph
  end

  def traverse(neighbor, path_total)
    return if (path_total >= [@graph[neighbor][:least_distance], @best_distance].min)

    if neighbor[0,2] == [@max_x,@max_y]
      @best_distance = path_total
      return
    end

    @graph[neighbor][:least_distance] = path_total

    @graph[neighbor][:neighbors].each do |next_neighbor, path_value|
      traverse(next_neighbor, path_total + path_value)
    end
  end

  def run
    traverse(@start_node, 0)
    puts @best_distance
  end
end

# Part 1
Day17Solver.new(1, 3).run
# Part 2
Day17Solver.new(4, 10).run
