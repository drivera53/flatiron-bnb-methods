class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5,
    only_integer: true
  }
  validates :description, presence: true

  validates :reservation, presence: true
  validate :reservation_accepted
  validate :checked_out

  private

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end
end
