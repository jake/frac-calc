require "pp"

resolution = 32

decimals = { 0.0 => "0" }

resolution.times do |i|
  decimal = i.next.to_f / resolution.to_f

  decimals[decimal] = decimal.to_r.to_s
end

pp decimals

# input = 0.19494
input = 10.19494
# input = 10.125
# input = 0.125

# split input into integer and decimal
input_integer,input_decimal = input.divmod(1)

output = "#{input} is "

# use whole integer as fraction prefix
human_integer = "#{input_integer} " if input_integer > 0

if decimals[input_decimal]
  output += "exactly #{human_integer}#{decimals[input_decimal]} inches"
else
  min = nil
  max = nil

  decimals.keys.each do |decimal|
    min = decimal if decimal < input_decimal
    max = decimal if decimal > input_decimal && max.nil?
  end

  output += "between #{human_integer}#{decimals[min]} and #{human_integer}#{decimals[max]} "

  output += "(#{input_integer + min} and #{input_integer + max})"
end

pp output