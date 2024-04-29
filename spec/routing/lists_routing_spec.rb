require "rails_helper"

RSpec.describe ListsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/boards/1/lists/new").to route_to("lists#new", board_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/lists/1/edit").to route_to("lists#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/boards/1/lists").to route_to("lists#create", board_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/lists/1").to route_to("lists#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/lists/1").to route_to("lists#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/lists/1").to route_to("lists#destroy", id: "1")
    end
  end
end
