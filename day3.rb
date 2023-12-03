INPUT_FILENAME = "day3-input.txt"

# Part One
sum = 0

rows = File.open(INPUT_FILENAME).readlines.map(&:strip)

assumed_row_length = rows.first.length + 2

# Add a row of dots around the edge of the input
rows.map! { |row| ".#{row}." }
rows.unshift("." * assumed_row_length)
rows << "." * assumed_row_length

# Now go through the array and sum up the numbers that are not fully surrounded by dots
rows.each_with_index do |row, row_num|
  digit = false
  current_number = ""
  current_number_box_start = 0
  current_number_box_end = 0

  row.chars.each_with_index do |char, char_num|
    if /[0-9]/ =~ char
      current_number_box_start = char_num - 1 unless digit

      digit = true
      current_number << char
    else
      if digit
        # Then number ended
        current_number_box_end = char_num
        
        # Check if it should be added
        
               # Is the top row all dots?
        unless rows[row_num - 1][current_number_box_start..current_number_box_end].chars.all?(".") &&
               # Is the bottom row all dots?
               rows[row_num + 1][current_number_box_start..current_number_box_end].chars.all?(".") &&
               # Is the left char a dot?
               rows[row_num][current_number_box_start] == "." &&
               # Is the right char a dot?
               rows[row_num][current_number_box_end] == "."
          sum += current_number.to_i
        end

        digit = false
        current_number = ""
      end
    end
  end
end

puts sum

# Part Two

# Use the same strategy to create a db of numbers and their surrounding "boxes"
# Then check what stars are in exactly two boxes
sum = 0
number_boxes = []

rows = File.open(INPUT_FILENAME).readlines.map(&:strip)

assumed_row_length = rows.first.length + 2

# Add a row of dots around the edge of the input
rows.map! { |row| ".#{row}." }
rows.unshift("." * assumed_row_length)
rows << "." * assumed_row_length

rows.each_with_index do |row, row_num|
  digit = false
  current_number = ""
  current_number_box_start = 0
  current_number_box_end = 0

  row.chars.each_with_index do |char, char_num|
    if /[0-9]/ =~ char
      current_number_box_start = char_num - 1 unless digit

      digit = true
      current_number << char
    else
      if digit
        # Then number ended
        current_number_box_end = char_num
        
        # Add to list of boxes
        number_boxes << {
          number: current_number.to_i,
          row_box_start: row_num - 1,
          row_box_end: row_num + 1,
          char_box_start: current_number_box_start,
          char_box_end: current_number_box_end,
        }

        digit = false
        current_number = ""
      end
    end
  end
end

gear_sum = 0

rows.each_with_index do |row, row_num|
  row.chars.each_with_index do |char, char_num|
    next if char != "*"

    matching_boxes = number_boxes.select do |box|
      row_num >= box[:row_box_start] &&
        row_num <= box[:row_box_end] &&
        char_num >= box[:char_box_start] &&
        char_num <= box[:char_box_end]
    end

    if matching_boxes.size == 2
      gear_sum += matching_boxes.map { |box| box[:number] }.inject(:*)
    end
  end
end

puts gear_sum

