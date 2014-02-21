class FormObject
  extend ActiveModel::Naming, ActiveModel::Translation
  include ActiveModel::Conversion, ActiveModel::Validations
  include Virtus.model

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def add_errors(objs_with_errors)
    Array(objs_with_errors).each do |object|
      self.errors.messages.merge!(object.errors)
    end
  end

  private

  def persist!
    raise "#{self.class.name} must define #persist!"
  end
end

