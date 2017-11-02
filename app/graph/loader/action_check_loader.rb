class ActionCheckLoader < GraphQL::Batch::Loader
  def initialize(action, user_id, type)
    case action
    when :bookmark
      @model = Bookmark
      @polymorphic = 'bookmarkable'
    when :downvote
      @model = Downvote
      @polymorphic = 'downvotable'
    when :follow
      @model = Follow
      @polymorphic = 'followable'
    when :thank
      @model = Thank
      @polymorphic = 'thankable'
    when :upvote
      @model = Upvote
      @polymorphic = 'upvotable'
    else
      raise ArgumentError, 'Invalid action'
    end

    @user_id = user_id
    @type = type
  end

  def perform(ids)
    @model.where(user_id: @user_id, "#{@polymorphic}_type" => @type, "#{@polymorphic}_id" => ids).each do |record|
      fulfill(record.send("#{@polymorphic}_id"), true)
    end
    ids.each { |id| fulfill(id, false) unless fulfilled?(id) }
  end
end
