class DatePickerInput < SimpleForm::Inputs::Base
  def input
    options = {"data-behaviour" => "datepicker"}.merge(input_html_options)
    @builder.text_field(attribute_name, options)
  end
end
