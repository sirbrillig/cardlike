class Cardlike::Card
  attr_accessor :name, :text

  def initialize(options={})
    self.name = options[:name]
    self.text = options[:text]
  end

  def text(card_text=nil)
    return @text unless card_text
    @text = card_text
  end
end
