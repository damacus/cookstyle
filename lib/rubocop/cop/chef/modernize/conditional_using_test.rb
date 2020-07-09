#
# Copyright:: 2019, Chef Software, Inc.
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module RuboCop
  module Cop
    module Chef
      module ChefModernize
        # Use ::File.exist?('/foo/bar') instead of the slower 'test -f /foo/bar' which requires shelling out
        #
        # @example
        #
        #   # bad
        #   only_if 'test -f /bin/foo'
        #
        #   # good
        #   only_if { ::File.exist?('bin/foo') }
        #
        class ConditionalUsingTest < Cop
          MSG = "Use ::File.exist?('/foo/bar') instead of the slower 'test -f /foo/bar' which requires shelling out".freeze

          def_node_matcher :resource_conditional?, <<~PATTERN
          (send nil? {:not_if :only_if} $str )
          PATTERN

          def on_send(node)
            resource_conditional?(node) do |conditional|
              add_offense(node, location: :expression, message: MSG, severity: :refactor) if conditional.value.match?(/^test -[ef] \S*$/)
            end
          end

          def autocorrect(node)
            lambda do |corrector|
              resource_conditional?(node) do |conditional|
                new_string = "{ ::File.exist?('#{conditional.value.match(/^test -[ef] (\S*)$/)[1]}') }"
                corrector.replace(conditional.loc.expression, new_string)
              end
            end
          end
        end
      end
    end
  end
end
