# frozen_string_literal: true

class CommentsMailer < ActionMailer::Base
  default from: ENV["NLT_DEFAULT_FROM"]

  def create(ad_id, comment)
    @comment = comment
    @ad = Ad.find ad_id

    mail to: @ad.user.email, subject: t("nlt.comments.subject", ad: @ad.title)
  end
end
