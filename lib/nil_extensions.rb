class NilClass
  def to_d
    BigDecimal 0
  end
  
  def percent_of n
    0.percent_of n
  end
  
  def percent
    0.percent
  end
  
  def changed?
    false
  end
  
  def admin?
    false
  end
  
  def > n
    0 > n
  end
end
