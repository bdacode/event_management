class ServiceResult
  include Virtus.model

  module Status
    SUCCESSFUL = 'successful'
    ERROR = 'error'
  end

  attribute :status, String, default: Status::ERROR
  attribute :errors, Object, default: ->(sr,_) { ActiveModel::Errors.new(sr) }
  attribute :exception, StandardError

  def successful!; self.status =  Status::SUCCESSFUL; end
  def successful?; self.status == Status::SUCCESSFUL; end
  def error!;      self.status =  Status::ERROR; end
  def error?;      self.status == Status::ERROR; end

  def add_error_message(message)
    errors.add(:base, message)
  end

  def add_errors(obj_with_errors)
    Array(obj_with_errors).each do |obj|
      self.errors.messages.merge!(obj.errors) unless obj.errors.empty?
    end
  end
:wa


  def add_errors_or_successful!(obj_with_errors)
    add_errors(obj_with_errors)
    successful! if errors.empty?
    self
  end
end

