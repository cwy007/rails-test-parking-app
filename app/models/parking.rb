class Parking < ApplicationRecord
  belongs_to :user, :optional => true
  before_validation :setup_amount
  validates_presence_of :parking_type, :start_at
  validates_inclusion_of :parking_type, :in => ["guest", "short-term", "long-term"]
  validate :validate_end_at_with_amount  # NOTE: 自定义一个检查规则 validate

  def validate_end_at_with_amount
    if ( end_at.blank? && amount.present? )
      errors.add(:end_at, "有金额就必须有结束时间")
    end
  end

  def duration
    ( end_at - start_at ) / 60
  end

  def setup_amount
    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      if self.user.blank?
        self.amount = calculate_guest_term_amount
      elsif self.parking_type == 'short-term'
        self.amount = calculate_short_term_amount
      elsif self.parking_type == 'long-term'
        self.amount = calculate_long_term_amount
      end
    end
  end

  def calculate_guest_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = 200 + ((duration - 60).to_f / 30).ceil * 100
    end
  end

  def calculate_short_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = 200 + ((duration - 60).to_f / 30).ceil * 50
    end
  end

  def calculate_long_term_amount
    if duration <= 1440
      self.amount = (duration > 360)? 1600 : 1200
    else
      t = duration % 1440
      within_one_day = 0
      if t > 0 && t <= 360         # 48 hours test example
        within_one_day = 1200
      elsif t > 360
        within_one_day = 1600
      end
      self.amount = (duration / 1440).floor * 1600 + within_one_day
    end
  end
end
