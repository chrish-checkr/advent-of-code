INPUT_FILENAME = "day21-input.txt"

class Day21Solver
  def initialize
    @nodes = {}
    @start_coords = nil
    File.open(INPUT_FILENAME).each_with_index do |row, y_idx|
      row = row.strip
      row.chars.each_with_index do |char, x_idx|
        @nodes[[x_idx, y_idx]] = { node: char, neighbors: [] }
        @start_coords = [x_idx, y_idx] if char == "S"
      end
    end

    @nodes.each do |coords, node|
      [[1,0], [0,1], [-1,0], [0,-1]].each do |move|
        neighbor_coords = [coords, move].transpose.map(&:sum)
        if @nodes[neighbor_coords] && @nodes[neighbor_coords][:node] != "#"
          node[:neighbors] << neighbor_coords
        end
      end
    end

    # puts @nodes.to_s
    # puts "-" * 25
    # puts @nodes.select { |coords, node| node[:node] == "S" }.to_s

    @visited_nodes = []
    @answers = []
  end

  def solve_part_one
    @queue = [[@start_coords, 64]]
    while !@queue.empty?
      next_coord, distance_remaining = @queue.shift
      traverse(next_coord, distance_remaining)
    end
    puts @answers.count
  end

  def traverse(current_coords, distance_remaining)
    if @visited_nodes.include?(current_coords)
      return
    else
      @visited_nodes << current_coords
    end

    @answers << current_coords if distance_remaining.even?
    return if distance_remaining == 0

    @nodes[current_coords][:neighbors].each do |neighbor_coords|
      @queue.push([neighbor_coords, distance_remaining - 1])
    end
  end
end

Day21Solver.new.solve_part_one
