class CoordinateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value && CoordinateService.coord?(value)
      record.errors.add(attribute, options[:message] || :is_not_coordinate)
    end
  end
end
