module ModelHelper
  def han(model, attribute)
    model.to_s.classify.constantize.human_attribute_name(attribute)
  end

  def model_states(model, state_machine = :state)
    model.to_s.classify.constantize \
      .state_machines[state_machine] \
      .states
  end

  def human_state_names(model, state_machine = :state)
    model_states(model, state_machine).map(&:human_name)
  end

  def human_state_select_options(model, state_machine = :state)
    options_from_collection_for_select(model_states(model), "name", "human_name")
  end
end
