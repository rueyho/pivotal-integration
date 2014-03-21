# Git Pivotal Tracker Integration
# Copyright (c) 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'base'
require 'pivotal-tracker'

# The class that encapsulates assigning current Pivotal Tracker Story to a user
class PivotalIntegration::Command::Mark < PivotalIntegration::Command::Base
  desc "Mark the current story with a given state"

  STATES = %w(unstarted started finished delivered rejected accepted)

  # Assigns story to user.
  # @return [void]
  def run(*arguments)
    state = arguments.first
    state = choose_state if state.nil? or !STATES.include?(state)

    PivotalIntegration::Util::Story.mark(story, state)
  end

  private

  def choose_state
    choose do |menu|
      menu.prompt = 'Choose story state from above list: '
      STATES.each do |state|
        menu.choice(state)
      end
    end
  end
end
