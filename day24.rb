INPUT_FILENAME = "day24-input.txt"

MIN_RANGE = 200000000000000
MAX_RANGE = 400000000000000

class Hailstone
  attr_reader :x, :y, :z, :vx, :vy, :vz

  def initialize(x, y, z, vx, vy, vz)
    @x = x
    @y = y
    @z = z
    @vx = vx
    @vy = vy
    @vz = vz
  end

  # y = ax + b form
  def a
    @a ||= vy.to_f / vx
  end

  def b
    @b ||= y - (a * x)
  end

  def equation
    "y = #{a} x + #{b}]"
  end
end

stones = []
File.open(INPUT_FILENAME).each do |row|
  next if row.strip == ""

  stones << Hailstone.new(
    *row.strip.gsub(/\s/,"").split(/,|\@/).map(&:to_i)
  )
end

puts stones.map(&:equation)

sum = 0
stones.combination(2).to_a.each do |pair|
  intersection = [
    (pair[1].b - pair[0].b) / (pair[0].a - pair[1].a), # (b2 - b1)/(a1 - a2)
    ((pair[0].a * pair[1].b) - (pair[1].a * pair[0].b)) / (pair[0].a - pair[1].a), # (a1 b2 - a2 b1)/(a1 - a2)
  ]
  next if intersection[0] < MIN_RANGE || intersection[1] < MIN_RANGE || intersection[0] > MAX_RANGE || intersection[1] > MAX_RANGE

  next if (intersection[0] - pair[0].x).positive? && pair[0].vx.negative?
  next if (intersection[1] - pair[0].y).positive? && pair[0].vy.negative?
  next if (intersection[0] - pair[0].x).negative? && pair[0].vx.positive?
  next if (intersection[1] - pair[0].y).negative? && pair[0].vy.positive?

  next if (intersection[0] - pair[1].x).positive? && pair[1].vx.negative?
  next if (intersection[1] - pair[1].y).positive? && pair[1].vy.negative?
  next if (intersection[0] - pair[1].x).negative? && pair[1].vx.positive?
  next if (intersection[1] - pair[1].y).negative? && pair[1].vy.positive?

  sum += 1
end

puts sum

