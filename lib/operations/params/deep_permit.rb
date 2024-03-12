# frozen_string_literal: true

module Operations
  module Params
    class DeepPermit
      class << self
        def call(params)
          permitted = params.permit(params.keys)
          not_permitted = params.keys - permitted.keys

          not_permitted.each do |(param, _)|
            permitted[param] = call(params.require(param))
          end

          permitted.to_h
        end
      end
    end
  end
end
