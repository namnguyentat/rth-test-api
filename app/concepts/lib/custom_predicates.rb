module CustomPredicates
  include Dry::Logic::Predicates

  predicate(:exists?) do |klass, value|
    klass.exists?(value)
  end
end
