module SuperDiff
  module ActiveRecord
    module ObjectInspection
      module InspectionTreeBuilders
        class ActiveRecordModel < SuperDiff::ObjectInspection::InspectionTreeBuilders::Base
          def self.applies_to?(value)
            value.is_a?(::ActiveRecord::Base)
          end

          def call
            SuperDiff::ObjectInspection::InspectionTree.new do |t1|
              t1.as_lines_when_rendering_to_lines(
                collection_bookend: :open
              ) do |t2|
                t2.add_text "#<#{object.class} "

                # stree-ignore
                t2.when_rendering_to_lines do |t3|
                  t3.add_text "{"
                end
              end

              t1.nested do |t2|
                t2.insert_separated_list(
                  ["id"] + (object.attributes.keys.sort - ["id"])
                ) do |t3, name|
                  t3.as_prefix_when_rendering_to_lines do |t4|
                    t4.add_text "#{name}: "
                  end

                  t3.add_inspection_of object.read_attribute(name)
                end
              end

              t1.as_lines_when_rendering_to_lines(
                collection_bookend: :close
              ) do |t2|
                # stree-ignore
                t2.when_rendering_to_lines do |t3|
                  t3.add_text "}"
                end

                t2.add_text ">"
              end
            end
          end
        end
      end
    end
  end
end
