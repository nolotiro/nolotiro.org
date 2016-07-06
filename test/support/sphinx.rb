# frozen_string_literal: true
#
# Some helpers for testing with sphinx indices
#
module SphinxHelpers
  def index
    sphinx_test_module.index

    # Wait for Sphinx to finish loading in the new index files.
    sleep 0.25 until index_finished?
  end

  private

  def index_finished?
    Dir[index_glob].empty?
  end

  def index_glob
    Rails.root.join(sphinx_test_module.config.indices_location, '*.{new,tmp}*')
  end

  def sphinx_test_module
    ThinkingSphinx::Test
  end
end
