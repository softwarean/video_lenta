module ApplicationType
  extend ActiveSupport::Concern

  module ClassMethods
    def model_name
      superclass.model_name
    end

    def name
      superclass.name
    end

    def permit(*args)
      @_args = args
    end

    def _args
      @_args
    end

    # from rolify
    def adapter
      superclass.adapter
    end
  end

  def assign_attributes(attrs = {})
    attrs = ActionController::Parameters.new(attrs) unless attrs.is_a?(ActionController::Parameters)
    permitted_attrs = attrs.send :permit, self.class._args
    super(permitted_attrs)
  end
end
