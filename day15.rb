INPUT_FILENAME = "day15-input.txt"

# Part One

answer_sum = 0

File.open(INPUT_FILENAME).each do |row|
  row.strip.split(",").each do |instruction|
    current_val = 0
    instruction.chars.each do |char|
      current_val += char.ord
      current_val *= 17
      current_val = current_val % 256
    end
    answer_sum += current_val
  end
end

puts answer_sum

# Part Two

answer_sum = 0
boxes = Hash.new([])

File.open(INPUT_FILENAME).each do |row|
  row.strip.split(",").each do |instruction|
    label = instruction.split(/-|=/)[0]

    current_val = 0
    label.chars.each do |char|
      current_val += char.ord
      current_val *= 17
      current_val = current_val % 256
    end
    box_num = current_val

    if instruction.include?("-")
      boxes[box_num] = boxes[box_num].select { |lens| lens[0] != label }
    else
      focal_length = instruction.split("=")[1]
      existing_val = boxes[box_num].select { |lens| lens[0] == label }[0]
      if !existing_val.nil?
        existing_val[1] = focal_length.to_i
      else
        boxes[box_num] = boxes[box_num].dup.concat([[label, focal_length.to_i]])
      end
    end
  end
end

boxes.each do |box_num, lenses|
  lenses.each_with_index do |lens, idx|
    answer_sum += ((box_num + 1) * (idx + 1) * lens[1])
  end
end

puts answer_sum
