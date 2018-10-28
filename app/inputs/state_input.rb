class StateInput < SimpleForm::Inputs::CollectionSelectInput
  def input
    collection = object.state_transitions
    value_method = :to
    label_method = :human_to_name
    input_options = {include_blank: false}
    @builder.collection_select(attribute_name, collection, value_method,
                               label_method, input_options, input_html_options)
  end
end
