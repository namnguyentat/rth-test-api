class ManyToManyLoader < GraphQL::Batch::Loader
  def initialize(model, mapping_class, target_fk, source_fk, order_by, order)
    @model = model
    @mapping_class = mapping_class
    @target_fk = target_fk
    @source_fk = source_fk
    @order_by = order_by
    @order = order
  end

  def perform(ids)
    mappings = @mapping_class.where(@source_fk => ids).order(@order_by => @order)
    objects = @model.where(id: mappings.map { |mapping| mapping.send(@target_fk) }.uniq)

    object_index = Hash[objects.collect { |object| [object.id, object] }]

    ids.each do |id|
      results = []

      mappings.each do |mapping|
        next if mapping.send(@source_fk) != id
        results << object_index[mapping.send(@target_fk)]
      end

      fulfill(id, results)
    end
  end
end
