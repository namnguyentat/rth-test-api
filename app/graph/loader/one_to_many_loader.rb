class OneToManyLoader < GraphQL::Batch::Loader
  def initialize(model, source_fk, order_by, order)
    @model = model
    @source_fk = source_fk
    @order_by = order_by
    @order = order
  end

  def perform(ids)
    objects = @model.where(@source_fk => ids).order(@order_by => @order)

    ids.each do |id|
      fulfill(id, objects.select { |object| object.send(@source_fk) == id })
    end
  end
end
