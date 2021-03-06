module Cardlike
  # 
  # Increment the score for a target (usually a string or symbol).
  #
  #   Cardlike.score "player 1" # => sets the score to 1
  #
  def self.score(target)
    @scores ||= {}
    @scores[target] ||= 0
    @scores[target] += 1
  end

  # 
  # Clear all scores.
  #
  def self.clear_scores
    @scores = {}
  end

  # 
  # Return the hash of the form <tt>{target: score}</tt>.
  #
  def self.scores
    @scores ||= {}
    @scores
  end

  # 
  # Retrieve the score for a target (usually a string or symbol).
  #
  #   Cardlike.score "player 1" # => sets the score to 1
  #   Cardlike.score "player 1" # => sets the score to 2
  #   Cardlike.the_score "player 1" # => 2
  #
  def self.the_score(target)
    @scores ||= {}
    @scores[target] || 0
  end

  # 
  # Set the score for a target to a particular value.
  #
  def self.set_score(target, value)
    @scores ||= {}
    @scores[target] = value
  end
end
