class List < ApplicationRecord
  belongs_to :user
  belongs_to :board
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true

  before_create :set_position

  private

    def set_position
      self.prev_position = board.lists.last&.position || 0
      self.position = self.prev_position + 1
    end
end
