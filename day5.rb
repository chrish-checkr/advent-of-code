INPUT_FILENAME = "day5-input.txt"

# Part One

sum = 0

seeds = []
seed_to_soil = []
soil_to_fert = []
fert_to_water = []
water_to_light = []
light_to_temp = []
temp_to_humx = []
humx_to_locx = []

all_arrays = [
  seed_to_soil,
  soil_to_fert,
  fert_to_water,
  water_to_light,
  light_to_temp,
  temp_to_humx,
  humx_to_locx
]

current_map = nil

# Build maps
File.open(INPUT_FILENAME).each do |row|
  next if row.strip == ""

  if row.start_with?("seeds:")
    seeds.concat(row.split(":").last.split(" ").map(&:to_i))
  elsif row.start_with?("seed-to-soil map:")
    current_map = seed_to_soil
  elsif row.start_with?("soil-to-fertilizer map:")
    current_map = soil_to_fert
  elsif row.start_with?("fertilizer-to-water map:")
    current_map = fert_to_water
  elsif row.start_with?("water-to-light map:")
    current_map = water_to_light
  elsif row.start_with?("light-to-temperature map:")
    current_map = light_to_temp
  elsif row.start_with?("temperature-to-humidity map:")
    current_map = temp_to_humx
  elsif row.start_with?("humidity-to-location map:")
    current_map = humx_to_locx
  else
    nums = row.split(" ").map(&:to_i)
    current_map << nums
  end
end

# Use maps to do stuff
results = []

seeds.each do |seed|
  current_mapped_num = seed
  all_arrays.each do |array|
    array.each do |mapping|
      if current_mapped_num >= mapping[1] && current_mapped_num < mapping[1] + mapping[2]
        current_mapped_num = mapping[0] + current_mapped_num - mapping[1]
        break
      end
    end
  end
  results << current_mapped_num
end

puts results.min

# Part Two

# Had to do a run through with a random sample of every 1k numbers to grab the likely "region" of the answer
MAGIC_NUMBER = 3454726619

# Build maps
File.open(INPUT_FILENAME).each do |row|
  next if row.strip == ""

  if row.start_with?("seeds:")
    pairs = row.split(":").last.split(" ").map(&:to_i).each_slice(2)
    pairs.each do |pair|
      seeds.concat((pair[0]..(pair[0] + pair[1] - 1)).to_a.select { |num| num > MAGIC_NUMBER - 1000 && num < MAGIC_NUMBER + 1000})
    end
  elsif row.start_with?("seed-to-soil map:")
    current_map = seed_to_soil
  elsif row.start_with?("soil-to-fertilizer map:")
    current_map = soil_to_fert
  elsif row.start_with?("fertilizer-to-water map:")
    current_map = fert_to_water
  elsif row.start_with?("water-to-light map:")
    current_map = water_to_light
  elsif row.start_with?("light-to-temperature map:")
    current_map = light_to_temp
  elsif row.start_with?("temperature-to-humidity map:")
    current_map = temp_to_humx
  elsif row.start_with?("humidity-to-location map:")
    current_map = humx_to_locx
  else
    nums = row.split(" ").map(&:to_i)
    current_map << nums
  end
end

# Use maps to do stuff
results = []

seeds.each do |seed|
  current_mapped_num = seed
  all_arrays.each do |array|
    array.each do |mapping|
      if current_mapped_num >= mapping[1] && current_mapped_num < mapping[1] + mapping[2]
        current_mapped_num = mapping[0] + current_mapped_num - mapping[1]
        break
      end
    end
  end
  results << [seed, current_mapped_num]
end

puts results.min_by { |res| res[1] } 
