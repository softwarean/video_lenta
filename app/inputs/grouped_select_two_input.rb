class GroupedSelectTwoInput < SimpleForm::Inputs::GroupedCollectionSelectInput
  def input
    label_method, value_method = detect_collection_methods

    input_html_options = {class: 'selectTwo'}

    input_options = {include_blank: false}
    @builder.grouped_collection_select(attribute_name, grouped_collection,
                      group_method, group_label_method, value_method, label_method,
                      input_options, input_html_options)
  end
end
