class Cardlike::Card
  attr_accessor :name, :text

  def initialize(options={})
    self.name = options[:name]
    self.text = options[:text]
    @properties = {}
  end

  def text(card_text=nil)
    return @text unless card_text
    @text = card_text
  end

  def property(prop)
    @properties[prop.to_sym] = nil
    self.instance_eval do
      define_method prop.to_sym, lambda { |v| @properties[prop.to_sym] = v }
    end
  end

  def [](prop)
    @properties[prop]
  end

  def has(prop)
    self.class.send(:define_method, prop, lambda { |arg| @properties[prop] = arg })
  end

end
