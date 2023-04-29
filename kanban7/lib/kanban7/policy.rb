
module Kanban7::Policy
    extend ActiveSupport::Concern

    class_methods do
        def policy(name, policy_object)
            class_eval <<-METHODS, __FILE__, __LINE__ + 1
                def #{name}_policies
                    @#{name}_policies ||= Hash.new
                end
            
                def include_#{name}_policy(name, policy_lambda)
                    #{name}_policies[name] = policy_lambda
                end
            
                def can_#{name}?(target_object, #{policy_object})
                    return true if #{policy_object}.nil?
                    #{name}_policies.all? { |name, policy| policy.call(target_object, #{policy_object}) }
                end
            METHODS
        end

        def user_policy(name)
            policy(name, :user)
        end
    end
end
