module SuperDiff
  module ObjectInspection
    module Nodes
      class AsLinesWhenRenderingToLines < Base
        def self.node_name
          :as_lines_when_rendering_to_lines
        end

        def self.method_name
          :as_lines_when_rendering_to_lines
        end

        def initialize(
          tree,
          *args,
          add_comma: false,
          collection_bookend: nil,
          **rest,
          &block
        )
          super(tree, *args, **rest, &block)

          @add_comma = add_comma
          @collection_bookend = collection_bookend
        end

        def render_to_string(object)
          # TODO: This happens a lot, can we simplify this?
          string =
            (block ? render_to_string_in_subtree(object) : immediate_value.to_s)

          add_comma? ? string + "," : string
        end

        def render_to_lines(object, type:, indentation_level:)
          lines =
            if block
              render_to_lines_in_subtree(
                object,
                type: type,
                indentation_level: indentation_level,
                disallowed_node_names: %i[line as_lines_when_rendering_to_lines]
              )
            else
              [
                SuperDiff::Line.new(
                  type: type,
                  indentation_level: indentation_level,
                  value: immediate_value.to_s
                )
              ]
            end

          with_collection_bookend_added_to_last_line_in(
            with_add_comma_added_to_last_line_in(lines)
          )
        end

        private

        attr_reader :collection_bookend

        def add_comma?
          @add_comma
        end

        def with_collection_bookend_added_to_last_line_in(lines)
          if collection_bookend
            lines[0..-2] +
              [lines[-1].clone_with(collection_bookend: collection_bookend)]
          else
            lines
          end
        end

        def with_add_comma_added_to_last_line_in(lines)
          if add_comma?
            lines[0..-2] + [lines[-1].clone_with(add_comma: add_comma?)]
          else
            lines
          end
        end
      end
    end
  end
end
