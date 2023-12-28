INPUT_FILENAME = "day13-test.txt"

# Part One

patterns = []
current_pattern = []

File.open(INPUT_FILENAME).each do |row|
  if row.strip.empty? && !current_pattern.empty?
    patterns << { rows: current_pattern }
    current_pattern = []
  end

  current_pattern << row.strip unless row.strip.empty?
end

patterns << { rows: current_pattern } unless current_pattern.empty?

puts patterns.to_s

answer_sum = 0
patterns.each do |pattern|
  # Find matching rows and columns
  row_index = 0
  duplicate_consecutive_rows = [] # Store lowest index of matching row
  pattern[:rows].each_cons(2).each do |pair|
    duplicate_consecutive_rows << row_index if pair[0] == pair[1]
    row_index += 1
  end

  pattern[:duplicate_consecutive_rows] = duplicate_consecutive_rows

  column_index = 0
  pattern[:columns] = pattern[:rows].map(&:chars).transpose.map(&:join)

  duplicate_consecutive_columns = [] # Store lowest index of matching column
  pattern[:columns].each_cons(2).each do |pair|
    duplicate_consecutive_columns << column_index if pair[0] == pair[1]
    column_index += 1
  end

  pattern[:duplicate_consecutive_columns] = duplicate_consecutive_columns

  # Now determine whether any of the matches actually work
  answer_found = false
  pattern[:duplicate_consecutive_rows].each do |match_idx|
    next if answer_found

    next unless (0..([pattern[:rows].count - match_idx - 2, match_idx].min)).all? do |offset_idx|
      pattern[:rows][match_idx - offset_idx] == pattern[:rows][match_idx + 1 + offset_idx]
    end

    answer_found = true
    answer_sum += 100 * (match_idx + 1)
  end

  next if answer_found

  pattern[:duplicate_consecutive_columns].each do |match_idx|
    next if answer_found

    next unless (0..([pattern[:columns].count - match_idx - 2, match_idx].min)).all? do |offset_idx|
      pattern[:columns][match_idx - offset_idx] == pattern[:columns][match_idx + 1 + offset_idx]
    end

    answer_found = true
    answer_sum += match_idx + 1
    break
  end
end

puts answer_sum

# Part Two

patterns = []
current_pattern = []

File.open(INPUT_FILENAME).each do |row|
  if row.strip.empty? && !current_pattern.empty?
    patterns << { rows: current_pattern }
    current_pattern = []
  end

  current_pattern << row.strip unless row.strip.empty?
end

patterns << { rows: current_pattern } unless current_pattern.empty?

answer_sum = 0
patterns.each do |pattern|
  # Find matching rows and columns
  row_index = 0
  duplicate_consecutive_rows = [] # Store lowest index of matching row
  pattern[:rows].each_cons(2).each do |pair|
    count = 0
    pair[0].chars.each_with_index do |char, idx|
      count += 1 unless pair[1].chars[idx] == char
    end
    duplicate_consecutive_rows << row_index if [0,1].include?(count)
    row_index += 1
  end

  pattern[:duplicate_consecutive_rows] = duplicate_consecutive_rows

  column_index = 0
  pattern[:columns] = pattern[:rows].map(&:chars).transpose.map(&:join)

  duplicate_consecutive_columns = [] # Store lowest index of matching column
  pattern[:columns].each_cons(2).each do |pair|
    count = 0
    pair[0].chars.each_with_index do |char, idx|
      count += 1 unless pair[1].chars[idx] == char
    end
    duplicate_consecutive_columns << column_index if [0,1].include?(count)
    column_index += 1
  end

  pattern[:duplicate_consecutive_columns] = duplicate_consecutive_columns

  # Now determine whether any of the matches actually work
  answer_found = false
  pattern[:duplicate_consecutive_rows].each do |match_idx|
    next if answer_found

    mismatch_count = 0
    (0..([pattern[:rows].count - match_idx - 2, match_idx].min)).each do |offset_idx|
      mismatch_count += 1 unless pattern[:rows][match_idx - offset_idx] == pattern[:rows][match_idx + 1 + offset_idx]
    end

    if mismatch_count == 1
      answer_found = true
      answer_sum += 100 * (match_idx + 1)
    end
  end

  next if answer_found

  pattern[:duplicate_consecutive_columns].each do |match_idx|
    next if answer_found

    mismatch_count = 0
    (0..([pattern[:columns].count - match_idx - 2, match_idx].min)).each do |offset_idx|
      mismatch_count += 1 unless pattern[:columns][match_idx - offset_idx] == pattern[:columns][match_idx + 1 + offset_idx]
    end

    if mismatch_count == 1
      answer_found = true
      answer_sum += match_idx + 1
      break
    end
  end
end

puts answer_sum

# Just change logic so it can be off-by-one instead of perfectly the same

