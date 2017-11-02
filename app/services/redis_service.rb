class RedisService
  class << self
    def init
      @redis = Redis::Namespace.new(:rth_api, redis: Redis.new)
    end

    def redis
      @redis || Redis::Namespace.new(:rth_api, redis: Redis.new)
    end
  end
end
