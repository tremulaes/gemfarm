require 'json'

class A
  attr_accessor :a, :b

  def initialize(a, b)
    @a, @b = a, b
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var|
        hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end
  def from_json! string
    JSON.load(string).each do |var, val|
        self.instance_variable_set var, val
    end
  end
end

me = A.new([1,2,3,4], "hello")
puts me.a
puts me.b

puts me.to_json
# test = JSON.dump me
# puts test
# data = JSON.parse test
# puts data
# puts data.b