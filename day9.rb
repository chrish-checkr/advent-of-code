INPUT_FILENAME = "day9-input.txt"

# Part One

sum = 0

File.open(INPUT_FILENAME).each do |row|
  nums = row.split(" ").map(&:to_i)

  all_zeroes = false

  table = [nums]
  latest_nums = nums

  while !all_zeroes
    latest_nums = latest_nums.each_cons(2).map do |pair|
      pair[1] - pair[0]
    end

    table << latest_nums

    all_zeroes = true if latest_nums.all? { |num| num == 0 }
  end

  # puts table.map { |row| row.join(" ") }
  
  last_num = 0
  table.reverse.each do |row|
    last_num += row.last
    row << last_num
  end

  sum += last_num
end

puts sum

# Part Two

sum = 0

File.open(INPUT_FILENAME).each do |row|
  nums = row.split(" ").map(&:to_i)

  all_zeroes = false

  table = [nums]
  latest_nums = nums

  while !all_zeroes
    latest_nums = latest_nums.each_cons(2).map do |pair|
      pair[1] - pair[0]
    end

    table << latest_nums

    all_zeroes = true if latest_nums.all? { |num| num == 0 }
  end

  # puts table.map { |row| row.join(" ") }
  
  first_num = 0
  table.reverse.each do |row|
    first_num = row.first - first_num
    row << first_num
  end

  sum += first_num
end

puts sum
