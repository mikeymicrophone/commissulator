def find_or_fabricate model, attrs = {}
  model_klass = model.to_s.camelize.constantize
  if model_klass.where(attrs).count == 0 || die_roll(model_klass.where(attrs).count % 5)
    begin
      made = Fabricate model, attrs
    rescue ActiveRecord::RecordInvalid => error
      model_klass.last
    end
  else
    model_klass.where(attrs).offset(rand(model_klass.where(attrs).count)).first
  end
end

def die_roll faces = 6
  rand(faces) == 0
end
