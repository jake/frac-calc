require 'sinatra'

get "/:resolution/:input" do
  resolution = params[:resolution].to_i
  input = params[:input].to_f

  decimals = { 0.0 => "" }

  resolution.times do |i|
    # calculate decimal
    decimal = i.next.to_f / resolution.to_f

    # fraction, at current resolution
    decimals[decimal] = "#{i.next}/#{resolution}"

    # fraction, at lowest resolution
    decimals[decimal] += " (#{decimal.to_r})" unless decimal.to_r.denominator == resolution
  end

  # split input into integer and decimal
  input_integer,input_decimal = input.divmod(1)

  output = "At a resolution of 1/#{resolution},<br><br> #{input} is "

  # use whole integer as fractional prefix
  human_integer = "#{input_integer} " if input_integer > 0

  if decimals[input_decimal]
    output += "exactly <b>#{human_integer}#{decimals[input_decimal]}</b> inches "
  else
    min = nil
    max = nil

    decimals.keys.each do |decimal|
      min = decimal if decimal < input_decimal
      max = decimal if decimal > input_decimal && max.nil?
    end

    decimals[min] = "0" if min == 0 and input_integer == 0

    min_human = "#{human_integer}#{decimals[min]}"
    max_human = "#{human_integer}#{decimals[max]}"

    output += "between <b>#{min_human}</b> and <b>#{max_human}</b> inches "

    output += "(#{input_integer + min} and #{input_integer + max})"
  end

  output
end

get "/" do
  erb :index
end
