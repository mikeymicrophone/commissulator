class NilClass
  def to_d
    BigDecimal 0
  end
  
  def percent_of n
    0.percent_of n
  end
  
  def changed?
    false
  end
end
