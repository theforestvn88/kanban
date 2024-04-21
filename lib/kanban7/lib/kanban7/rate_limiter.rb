module Kanban7::RateLimiter
    extend ActiveSupport::Concern

    class_methods do
        def rate_limiter(name)
            class_eval <<-METHODS, __FILE__, __LINE__ + 1
                def #{name}_rate_limiters
                    @#{name}_rate_limiters ||= Hash.new
                end
                
                def include_#{name}_rate_limiter(key, rate_limiter_lambda, **cache_options)
                    #{name}_rate_limiters[key] = {
                        lambda: rate_limiter_lambda,
                        cache_options: cache_options
                    }
                end

                def #{name}_rate_limit!(user, ip)
                    #{name}_rate_limiters.each do |key, rate_limiter|
                        cache_key = key.to_s + (user&.id || ip).to_s
                        count = Rails.cache.read(cache_key).to_i
                        puts count
                        if rate_limiter[:lambda].call(user, ip, count)
                            Rails.cache.write(cache_key, count + 1, **rate_limiter[:cache_options])
                        else
                            raise LimitExceeded.new
                        end
                    end
                end
            METHODS
        end
    end

    class LimitExceeded < StandardError
    end
end
