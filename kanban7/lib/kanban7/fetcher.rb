module Kanban7::Fetcher
    extend ActiveSupport::Concern

    included do
        def fetch_lists=(fetch_lists_lambda)
            @configs[:fetch_lists_lambda] = fetch_lists_lambda
        end

        def fetch_lists
            @configs[:fetch_lists_lambda] ||= ->(board, params) {
                return fixed_lists if fixed_lists?

                list_model
                    .where(board_model_symbol => board)
                    .order(Arel.sql("CASE WHEN position IS NULL THEN id ELSE position END"))
                    .offset(params[:offset])
                    .limit(params[:limit])
            }
        end

        def fetch_cards=(fetch_cards_lambda)
            @configs[:fetch_cards_lambda] = fetch_cards_lambda
        end

        def fetch_cards
            @configs[:fetch_cards_lambda] ||= ->(list, params) {
                query = card_model
                if fixed_lists?
                    query = query.where(list_model_symbol => list.send(fixed_lists_save_as))
                else
                    query = query.where(list_model_symbol => list)
                end

                query = query.order(Arel.sql("CASE WHEN position IS NULL THEN id ELSE position END"))
                    .order(updated_at: :asc)
                    .offset(params[:offset])
                    .limit(params[:limit])
            }
        end
    end
end
