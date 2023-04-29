# frozen_string_literal: true

module Kanban7
    class BoardConfigs
        include Policy
        user_policy :move_card
        user_policy :modify_card
        user_policy :add_card
        user_policy :move_list
        user_policy :modify_list
        user_policy :add_list

        attr_reader :kanban_name

        def initialize(kanban_name)
            @kanban_name = kanban_name
            @configs = {}
        end

        def set_configs(configs)
            configs&.assert_valid_keys(
                :board_model, :header_board_partial,
                :list_model, :fixed_lists, :form_list_partial, :header_list_partial, :update_list_path, 
                :card_model, :form_card_partial, :item_card_partial, :update_card_path
            )
            @configs = configs || {}
        end

        def kanban_frame
            "#{@kanban_name}-kanban"
        end

        def board_model=(board)
            @configs[:board_model] = board
        end

        def board_model
            @board_model ||= @configs[:board_model]&.constantize
        end

        def board_model_name
            board_model.name.downcase
        end

        def board_model_symbol
            board_model_name.to_sym
        end

        def header_board_partial
            @configs[:header_board_partial] || "#{@kanban_name}_kanban/#{board_model_name.pluralize}/header"
        end

        def list_model=(list)
            @configs[:list_model] = list
        end

        def list_model
            @list_model ||= @configs[:list_model]&.constantize
        end

        def list_model_name
            @list_model_name ||= list_model.name.downcase
        end

        def list_model_symbol
            list_model_name.to_sym
        end

        def list_model_id_symbol
            @list_model_id_symbol ||= "#{list_model_name}_id".to_sym
        end

        def fetch_lists=(fetch_lists_lambda)
            @configs[:fetch_lists_lambda] = fetch_lists_lambda
        end

        def fetch_lists
            @configs[:fetch_lists_lambda]
        end

        def setup_fixed_lists(list, as:, save_attribute: :name)
            raise ArgumentError, "Please set up the fixed list" if list.empty?
            
            @list_model = as
            @list_model_name = as.downcase
            # @list_model_id_symbol = @list_model_name
            @configs[:fixed_lists] = list
            @configs[:fixed_lists_save_as] = save_attribute
        end

        def fixed_lists?
            @configs[:fixed_lists].present?
        end

        def fixed_lists
            return unless fixed_lists?
            @fixed_lists ||= FixedList.from(@configs[:fixed_lists], save_as: @configs[:fixed_lists_save_as])
        end

        def fixed_lists_save_as
            @configs[:fixed_lists_save_as]
        end

        def find_fixed_list(id)
            @fixed_lists&.find { |list| list.id == id }
        end

        def form_list_partial
            @configs[:form_list_partial] || "#{@kanban_name}_kanban/#{list_model_name.pluralize}/form"
        end

        def header_list_partial
            @configs[:header_list_partial] || "#{@kanban_name}_kanban/#{list_model_name.pluralize}/header"
        end

        def card_model=(card)
            @configs[:card_model] = card
        end

        def card_model
            @card_model ||= @configs[:card_model]&.constantize
        end

        def card_model_name
            card_model.name.downcase
        end

        def card_model_symbol
            card_model_name.to_sym
        end

        def card_parent_id_symbol
            fixed_lists? ? list_model_symbol : list_model_id_symbol
        end

        def fetch_cards=(fetch_cards_lambda)
            @configs[:fetch_cards_lambda] = fetch_cards_lambda
        end

        def fetch_cards
            @configs[:fetch_cards_lambda]
        end

        def form_card_partial
            @configs[:form_card_partial] || "#{@kanban_name}_kanban/#{card_model_name.pluralize}/form"
        end

        def item_card_partial
            @configs[:item_card_partial] || "#{@kanban_name}_kanban/#{card_model_name.pluralize}/card"
        end

        def detail_card_partial
            @configs[:detail_card_partial] || "#{@kanban_name}_kanban/#{card_model_name.pluralize}/#{card_model_name}"
        end
      end
end
