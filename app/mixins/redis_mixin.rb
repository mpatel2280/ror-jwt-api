# app/mixins/redis_mixin.rb
module RedisMixin
    extend ActiveSupport::Concern
  
    included do
      before_action :initialize_redis
    end
  
    def initialize_redis
      @redis = REDIS_CLIENT
    end
  
    def redis_write(key, value)
      @redis.set(key, value)
    end
  
    def redis_read(key)
      @redis.get(key)
    end

    def store_records_in_redis(key, records)
        json_records = records.to_json
        @redis.set(key, json_records)
    end
    
    def fetch_records_from_redis(key)
        json_records = @redis.get(key)
        return nil unless json_records

        JSON.parse(json_records)
    end

    def delete_records_from_redis(key)
        @redis.del(key)
    end

  end
  