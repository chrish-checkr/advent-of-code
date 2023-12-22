INPUT_FILENAME = "day22-test.txt"

class Block
  attr_accessor :x1, :y1, :z1, :x2, :y2, :z2

  def initialize(x1, y1, z1, x2, y2, z2)
    @x1 = x1.to_i
    @y1 = y1.to_i
    @z1 = z1.to_i
    @x2 = x2.to_i
    @y2 = y2.to_i
    @z2 = z2.to_i
  end

  def touches_ground?
    z1 == 1
  end

  def cells
    @cells ||= find_cells
  end

  def find_cells
    cell_builder = []
    (x1..x2).to_a.each do |x|
      (y1..y2).to_a.each do |y|
        (z1..z2).to_a.each do |z|
          cell_builder << [x,y,z]
        end
      end
    end
    cell_builder
  end

  def cells_below
    @cells_below ||= find_cells_below
  end

  def find_cells_below
    return [] if touches_ground?

    cell_builder = []
    (x1..x2).to_a.each do |x|
      (y1..y2).to_a.each do |y|
        cell_builder << [x,y,z1-1]
      end
    end
    cell_builder
  end

  def move_down!
    raise "Moving below the ground" if touches_ground?

    @z1 -= 1
    @z2 -= 1

    cells.map! do |cell|
      [cell[0], cell[1], cell[2]-1]
    end
    cells_below.map! do |cell|
      [cell[0], cell[1], cell[2]-1]
    end
  end

  def to_s
    [x1, y1, z1, x2, y2, z2, cells.count].join("|")
  end
end

class Day22Solver
  def initialize
    @blocks = []

    File.open(INPUT_FILENAME).each do |row|
      parts = row.strip.split(/,|~/)
      @blocks << Block.new(*parts)
    end

    @blocks = @blocks.sort_by(&:z1)

    @critical_blocks = []
    @supported_by_map = {}
    @supports_map = {}
  end

  def build_map
    @blocks.each do |block|
      while can_move_down?(block)
        block.move_down!
      end
    end

    @blocks.each do |block|
      supporting_blocks = @blocks.select { |other_block| !(other_block.cells & block.cells_below).empty? }
      @supported_by_map[block] = supporting_blocks

      supporting_blocks.each do |supporting_block|
        @supports_map[supporting_block] ||= []
        @supports_map[supporting_block] = @supports_map[supporting_block].concat([block]).compact.uniq
      end

      if supporting_blocks.size == 1
        @critical_blocks << supporting_blocks[0]
      end
    end

    @critical_blocks = @critical_blocks.uniq
  end

  def solve_part_one
    build_map
    puts @blocks.count - @critical_blocks.uniq.count
  end

  def can_move_down?(block)
    return false if block.touches_ground?

    @blocks.all? do |other_block|
      (block.cells_below & other_block.cells).empty?
    end
  end

  def solve_part_two
    part_two_sum = 0

    @critical_blocks.each do |block|
      disintegrated_blocks = [block]
      traverse_from_critical_block(block, disintegrated_blocks)
      part_two_sum += disintegrated_blocks.uniq.count - 1
    end
    puts part_two_sum
  end

  def traverse_from_critical_block(block, disintegrated_blocks)
    return if @supports_map[block].nil?

    @supports_map[block].each do |propped_up_block|
      if (@supported_by_map[propped_up_block] - disintegrated_blocks).empty?
        disintegrated_blocks << propped_up_block
        traverse_from_critical_block(propped_up_block, disintegrated_blocks)
      end
    end
  end
end

solver = Day22Solver.new
solver.solve_part_one
solver.solve_part_two
