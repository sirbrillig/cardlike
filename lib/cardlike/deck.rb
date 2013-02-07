class Cardlike::Deck < Array
  attr_accessor :name

  def initialize(options={})
    self.name = options[:name]
    options[:cards].each { |c| self << c } if options[:cards]
  end

  def draw
    self.pop
  end
end


