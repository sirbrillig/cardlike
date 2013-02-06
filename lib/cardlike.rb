require "cardlike/version"
require "cardlike/deck"
require "cardlike/card"

module Cardlike
  def self.version
    "#{self} version #{VERSION}"
  end
end
