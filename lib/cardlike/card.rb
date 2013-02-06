class Cardlike::Card
  attr_accessor :name, :text

  def initialize(options={})
    self.name = options[:name]
    self.text = options[:text]
  end

  def self.card(name, &block)
    klass = Class.new(Cardlike::Card)
    constant_name = name.gsub(/\s+/, '_')
    Object.const_set(constant_name, klass) if not Object.const_defined?(constant_name)
    c = Object.const_get(constant_name).new
    c.name = name
    c.class.class_eval(&block) if block_given?
  end

  def text(card_text=nil)
    return @text unless card_text
    @text = card_text
  end
end
