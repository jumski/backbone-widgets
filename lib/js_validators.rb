
class JsValidators
  def self.generate
    ActiveSupport::JSON.encode validations_hash
  end

  def self.validations_hash
    models.inject({}) do |validations, model|
      validations[model.class.name] = model.validators.count
      # validations[model.class.name] = model.validators.map do |validator|
      #   validator_to_hash validator
      # end
    end
  end

  def self.models
    [Announcement]
  end
end
