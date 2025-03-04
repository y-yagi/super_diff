module SuperDiff
  module ObjectInspection
    module InspectionTreeBuilders
      class Primitive < Base
        def self.applies_to?(value)
          SuperDiff.primitive?(value) || value.is_a?(::String)
        end

        def call
          InspectionTree.new do |t1|
            t1.as_lines_when_rendering_to_lines do |t2|
              t2.add_text object.inspect
            end
          end
        end
      end
    end
  end
end
