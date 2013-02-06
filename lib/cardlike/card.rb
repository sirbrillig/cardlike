class Cardlike::Card
  attr_accessor :name, :text

  def initialize(options={})
    self.name = options[:name]
    self.text = options[:text]
  end
end
