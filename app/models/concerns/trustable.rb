# frozen_string_literal: true

#
# Funcionality related to user trust levels
#
module Trustable
  def report_weight
    if tl3? then Report.max_allowed_report_score
    elsif tl2? then Report.max_allowed_report_score / 2
    elsif tl1? then Report.max_allowed_report_score / 3
    else 0
    end
  end

  def tl3?
    admin?
  end

  def tl2?
    ads.give.size >= 5 && confirmed_at >= 1.week.ago
  end

  def tl1?
    !tl0?
  end

  def tl0?
    confirmed_at >= 1.day.ago
  end
end
