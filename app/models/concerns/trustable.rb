# frozen_string_literal: true

#
# Funcionality related to user trust levels
#
module Trustable
  def report_weight
    if tl3? then max_allowed_report_score
    elsif tl2? then max_allowed_report_score / 2
    elsif tl1? then max_allowed_report_score / 3
    else 0
    end
  end

  def tl3?
    admin?
  end

  def tl2?
    ads.give.size >= 10 && confirmed_at < 1.month.ago
  end

  def tl1?
    !tl0?
  end

  def tl0?
    confirmed_at.nil? || confirmed_at > 1.day.ago
  end
end
