# frozen_string_literal: true

module Kanban7
    module Kanbanize
        extend ActiveSupport::Concern

        class_methods do
            def kanban(name)
                @@board_configs = Kanban7.fetch_board_configs(name)
                @@board_configs.fetch_lists = ->(board, params) {
                    return @@board_configs.fixed_lists if @@board_configs.fixed_lists?

                    @@board_configs.list_model
                        .where(@@board_configs.board_model_symbol => board)
                        .order(Arel.sql("CASE WHEN position IS NULL THEN id ELSE position END"))
                        .offset(params[:offset])
                        .limit(params[:limit])
                }
                
                @@board_configs.fetch_cards = ->(list, params) {
                    query = @@board_configs.card_model
                    if @@board_configs.fixed_lists?
                        query = query.where(@@board_configs.list_model_symbol => list.send(@@board_configs.fixed_lists_save_as))
                    else
                        query = query.where(@@board_configs.list_model_symbol => list)
                    end

                    query = query.order(Arel.sql("CASE WHEN position IS NULL THEN id ELSE position END"))
                        .order(updated_at: :asc)
                        .offset(params[:offset])
                        .limit(params[:limit])
                }
    
                yield @@board_configs
            end
        end

        included do
            def set_configs
                @board_configs = Kanban7.fetch_board_configs(params[:name])
            end

            def get_list
                if @board_configs.fixed_lists?
                    @list ||= @board_configs.find_fixed_list(params[@board_configs.list_model_id_symbol])
                else
                    @list ||= @board_configs.list_model.find(params[@board_configs.list_model_id_symbol])
                end
            end
        end
    end
end
