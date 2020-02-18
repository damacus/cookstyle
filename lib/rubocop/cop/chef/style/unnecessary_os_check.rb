#
# Copyright:: 2020, Chef Software, Inc.
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
      module ChefStyle
        # Use the platform_family?() helpers instead of node['os] == 'foo' for platform_families that match 1:1 with OS values. These helpers are easier to read and can accept multiple platform arguments, which greatly simplifies complex platform logic.
        #
        # @example
        #
        #   # bad
        #   node['os'] == 'darwin'
        #   node['os'] == 'windows'
        #   node['os'].eql?('aix')
        #   %w(netbsd openbsd freebsd).include?(node['os'])
        #
        #   # good
        #   platform_family?('mac_os_x')
        #   platform_family?('windows')
        #   platform_family?('aix')
        #   platform_family?('netbsd', 'openbsd', 'freebsd)
        #
        class UnnecessaryOSCheck < Cop
          MSG = "Use the platform_family?() helpers instead of node['os] == 'foo' for platform_families that match 1:1 with OS values.".freeze

          # sorted list of all the os values that match 1:1 with a platform_family
          UNNECESSARY_OS_VALUES = %w(aix darwin dragonflybsd freebsd netbsd openbsd solaris2 windows).freeze

          def_node_matcher :os_equals?, <<-PATTERN
            (send (send (send nil? :node) :[] (str "os") ) ${:== :!=} $str )
          PATTERN

          def_node_matcher :os_eql?, <<-PATTERN
          (send (send (send nil? :node) :[] (str "os") ) :eql? $str )
          PATTERN

          def_node_matcher :os_include?, <<-PATTERN
            (send $(array ...) :include? (send (send nil? :node) :[] (str "os")))
          PATTERN

          def on_send(node)
            os_equals?(node) do |_operator, val|
              if UNNECESSARY_OS_VALUES.include?(val.value)
                add_offense(node, location: :expression, message: MSG, severity: :refactor)
              end
            end

            os_eql?(node) do |val|
              if UNNECESSARY_OS_VALUES.include?(val.value)
                add_offense(node, location: :expression, message: MSG, severity: :refactor)
              end
            end

            os_include?(node) do |val|
              array_of_plats = array_from_ast(val)
              # see if all the values in the .include? usage are in our list of 1:1 platform family to os values
              if (UNNECESSARY_OS_VALUES & array_of_plats) == array_of_plats
                add_offense(node, location: :expression, message: MSG, severity: :refactor)
              end
            end
          end

          # return the passed value unless the value is darwin and then return mac_os_x
          def sanitized_platform(plat)
            plat == 'darwin' ? 'mac_os_x' : plat
          end

          # given an ast array spit out a ruby array
          def array_from_ast(ast)
            vals = []
            ast.each_child_node { |x| vals << x.value }
            vals.sort
          end

          def autocorrect(node)
            lambda do |corrector|
              os_equals?(node) do |operator, plat|
                corrected_string = operator == :!= ? '!' : ''
                corrected_string << "platform_family?('#{sanitized_platform(plat.value)}')"
                corrector.replace(node.loc.expression, corrected_string)
              end

              os_include?(node) do |plats|
                platforms = plats.values.map { |x| x.str_type? ? "'#{sanitized_platform(x.value)}'" : x.source }
                corrected_string = "platform_family?(#{platforms.join(', ')})"
                corrector.replace(node.loc.expression, corrected_string)
              end

              os_eql?(node) do |plat|
                corrected_string = "platform_family?('#{sanitized_platform(plat.value)}')"
                corrector.replace(node.loc.expression, corrected_string)
              end
            end
          end
        end
      end
    end
  end
end
