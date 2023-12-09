INPUT_FILENAME = "day6-input.txt"

# Part One
races = []

File.open(INPUT_FILENAME).each do |row|
  if row.start_with?("Time")
    row.split(" ").each_with_index do |time, idx|
      next if idx == 0

      races << { time: time.to_i }
    end
  elsif row.start_with?("Distance")
    row.split(" ").each_with_index do |distance, idx|
        next if idx == 0
  
        races[idx - 1][:distance] = distance.to_i
      end
  end
end

races.each do |race|
  win_count = 0
  (1..(race[:time]-1)).each do |hold_length|
    win_count += 1 if hold_length * (race[:time] - hold_length) > race[:distance]
  end

  race[:win_count] = win_count
end

puts races.map { |race| race[:win_count] }.inject(:*)
