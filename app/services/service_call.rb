class ServiceCall
  include Virtus.model

  # return object - defaults to creating the `result_class` object
  attribute :result, ServiceResult, default: ->(service,_) { service.result_class.new }

  def self.call(*args)
    new(*args).call
  end

  def result_class
    self.class.const_get("Result") rescue ServiceResult
  end

  protected

  def with_exception_catching
    begin
      yield
    rescue StandardError => exception
      Rails.logger.error "Exception occured: #{exception.message}\n#{exception.backtrace}"
      result.exception = exception
      result.add_errors(exception.record) if exception.respond_to?(:record)
    end
  end


end
