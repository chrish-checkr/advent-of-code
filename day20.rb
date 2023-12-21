INPUT_FILENAME = "day20-input.txt"

# broadcaster -> a, b, c
# %a -> b
# %b -> c
# %c -> inv
# &inv -> a

class Day20Solver
  def initialize
    @modules = []
    File.open(INPUT_FILENAME).each do |row|
      row = row.strip.gsub(/\s/,"")
      if row.start_with?("broadcaster")
        parts = row.split("->")
        @modules << {
          type: "broadcaster",
          key: "broadcaster",
          is_on: true, 
          pulses_received: {},
          pulse_destinations: parts[1].split(",")
        }
      elsif !row.empty?
        parts = row.split("->")
        @modules << {
          type: parts[0][0],
          key: parts[0][1..-1],
          is_on: false,
          pulses_received: {},
          pulse_destinations: parts[1].split(",")
        }
      end
    end

    # Initialize &s
    @modules.select { |mod| mod[:type] == "&" }.each do |mod|
      @modules.select { |modd| modd[:pulse_destinations].include?(mod[:key]) }.each do |modd|
        mod[:pulses_received][modd[:key]] = "L"
      end
    end

    @pulse_counts = Hash.new(0)

    @important_inputs = {
      "bm" => nil,
      "cl" => nil,
      "tn" => nil,
      "dr" => nil
    }
    @button_push_count = 0
  end

  def solve_part_one
    1_000.times do
      send_pulses([{ sender: "button", receiver: "broadcaster", type: "L" }])
    end

    puts @pulse_counts.to_s
    puts @pulse_counts.values.inject(:*)
  end

  def send_pulses(pulses)
    @output_pulses = []

    pulses.each do |pulse|
      send_pulse(pulse[:sender], pulse[:receiver], pulse[:type])
    end

    unless @output_pulses.empty?
      send_pulses(@output_pulses)
    end
  end

  def send_pulse(sender_key, receiver_key, pulse_type)
    @pulse_counts[pulse_type] += 1

    pulsed_module = @modules.find { |mod| mod[:key] == receiver_key }
    return if pulsed_module.nil? # "output"

    pulsed_module[:pulses_received].merge!({ sender_key => pulse_type })
    if pulsed_module[:type] == "%" && pulse_type == "L"
      pulsed_module[:is_on] = !pulsed_module[:is_on]
      new_pulse_type = pulsed_module[:is_on] ? "H" : "L"
      @output_pulses.concat pulsed_module[:pulse_destinations].map { |dest| { sender: receiver_key, receiver: dest, type: new_pulse_type } }
    elsif pulsed_module[:type] == "&"
      new_pulse_type = pulsed_module[:pulses_received].values.all?("H") ? "L" : "H"
      @output_pulses.concat pulsed_module[:pulse_destinations].map { |dest| { sender: receiver_key, receiver: dest, type: new_pulse_type } }
    elsif receiver_key == "broadcaster"
      @output_pulses.concat pulsed_module[:pulse_destinations].map { |dest| { sender: receiver_key, receiver: dest, type: pulse_type } }
    end

    if @important_inputs.keys.include?(receiver_key) && !pulsed_module[:pulses_received].values.all?("H") && !@important_inputs[receiver_key]
      @important_inputs[receiver_key] = @button_push_count.dup
    end
  end

  def solve_part_two
    10_000.times do
      @button_push_count += 1
      send_pulses([{ sender: "button", receiver: "broadcaster", type: "L" }])
    end

    puts @important_inputs.values.reduce(1, :lcm)
  end
end

Day20Solver.new.solve_part_one
Day20Solver.new.solve_part_two
