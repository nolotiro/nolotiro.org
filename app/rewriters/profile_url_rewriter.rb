# frozen_string_literal: true

#
# Rewrites old userads URLs to redirect to the unified profile
#
class ProfileUrlRewriter
  def call(_params, request)
    path = request.fullpath

    path.sub(old_userads_pattern, '\1/profile') if path.match?(old_userads_pattern)
  end

  private

  def old_userads_pattern
    %r{\A(/[a-z][a-z])?/ad/listuser/id}
  end
end
