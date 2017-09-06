# frozen_string_literal: true

require 'image_optim'

module Paperclip
  class Optimizer < Processor
    def make
      optimized_path = optimizer.optimize_image!(@file.path)
      return @file unless optimized_path

      File.new(optimized_path)
    end

    private

    def optimizer
      @optimizer ||= ImageOptim.new
    end
  end
end
