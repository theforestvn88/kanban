require "test_helper"

class DndTest < ApplicationSystemTestCase
    test "visiting the index" do
        visit("/")
        expect(page).to have_content 'Kanban'
    end
end
