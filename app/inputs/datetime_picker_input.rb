class DatetimePickerInput < SimpleForm::Inputs::StringInput
  def input
    input_html_classes.push('datetimepicker')
    super
  end
end
