# frozen_string_literal: true

module Legion
  module Extensions
    module CognitivePalimpsest
      class Client
        include Runners::CognitivePalimpsest

        def initialize(engine: nil)
          @default_engine = engine || Helpers::PalimpsestEngine.new
        end
      end
    end
  end
end
