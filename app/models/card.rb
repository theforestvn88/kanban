class Card < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :list

  validates :title, presence: true

  before_create :set_position

  private

    def set_position
      self.prev_position = list.cards.last&.position || 0
      self.position = self.prev_position + 1
    end
end
