# frozen_string_literal: true

require 'legion/extensions/cognitive_palimpsest/version'
require 'legion/extensions/cognitive_palimpsest/helpers/constants'
require 'legion/extensions/cognitive_palimpsest/helpers/belief_layer'
require 'legion/extensions/cognitive_palimpsest/helpers/palimpsest'
require 'legion/extensions/cognitive_palimpsest/helpers/palimpsest_engine'
require 'legion/extensions/cognitive_palimpsest/runners/cognitive_palimpsest'
require 'legion/extensions/cognitive_palimpsest/client'

module Legion
  module Extensions
    module Helpers
      module Lex; end
    end
  end
end

module Legion
  module Logging
    def self.method_missing(*); end

    def self.respond_to_missing?(*) = true
  end
end
