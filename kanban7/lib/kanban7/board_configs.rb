module Kanban7
    class BoardConfigs
        def initialize(board_name, configs)
            configs.assert_valid_keys(
                :board_model, :header_board_partial,
                :list_model, :fixed_lists, :form_list_partial, :header_list_partial, :update_list_path, 
                :card_model, :form_card_partial, :item_card_partial, :update_card_path
            )

            @board_name = board_name
            @configs = configs
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
            @configs[:header_board_partial] || "#{@board_name}_kanban/#{board_model_name.pluralize}/header"
        end

        def list_model
            @list_model ||= @configs[:list_model]&.constantize
        end

        def list_model_name
            list_model.name.downcase
        end

        def list_model_symbol
            list_model_name.to_sym
        end

        def is_fixed_lists?
            @configs[:fixed_lists].present?
        end

        def form_list_partial
            @configs[:form_list_partial] || "#{@board_name}_kanban/#{list_model_name.pluralize}/form"
        end

        def header_list_partial
            @configs[:header_list_partial] || "#{@board_name}_kanban/#{list_model_name.pluralize}/header"
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

        def form_card_partial
            @configs[:form_card_partial] || "#{@board_name}_kanban/#{card_model_name.pluralize}/form"
        end

        def item_card_partial
            @configs[:item_card_partial] || "#{@board_name}_kanban/#{card_model_name.pluralize}/item"
        end
      end
end
