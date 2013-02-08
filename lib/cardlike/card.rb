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

  def self.has(prop)
    define_method(prop, lambda { |arg| raise "Cards are immutable." if @properties.has_key? prop; @properties[prop] = arg })
  end

  def to_s
    t = []
    t << "Name: #{name}"
    t << "Text: #{text}" if text
    @properties.each { |p,v| t << "#{p}: #{v}" } 
    t.join("\n")
  end

end
