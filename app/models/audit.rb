class Audit < Auditable::Audit
  include Authority::Abilities
end
