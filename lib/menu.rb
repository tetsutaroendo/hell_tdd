require 'fizz_buzz'
require 'integer_validator'

class Menu

  def initialize(input, output)
    @input = input
    @output = output
  end

  def select(mode)
    if mode == '1'
      @output.puts('FizzBuzzをスタートします')
      number = @input.gets
      if IntegerValidator.new(number).valid?
        obj = FizzBuzz.new(number.to_i)
        @output.puts(obj.result)
      else
        @output.puts('整数を入力してください')
      end
    end
  end
end
