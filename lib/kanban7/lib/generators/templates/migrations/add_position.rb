class AddPositionTo<%= @table_name.camelize %> < ActiveRecord::Migration<%= @migration_version %>
    def change
      add_column :<%= @table_name %>, :position, :float
    end
end