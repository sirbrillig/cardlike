class Cardlike::Card
  attr_accessor :name, :text

  def initialize(options={})
    self.name = options[:name]
    self.text = options[:text]
    @properties = {}
  end

  def self.create(name, &block)
    c = self.new(name: name)
    c.instance_eval(&block) if block_given?
    c
  end

  def text(card_text=nil)
    return @text unless card_text
    @text = card_text
  end

  def [](prop)
    @properties[prop]
  end

  def has(prop)
    self.class.send(:define_method, prop, lambda { |arg| @properties[prop] = arg })
  end

  def self.has(prop)
    define_method(prop, lambda { |arg| @properties[prop] = arg })
  end

end
