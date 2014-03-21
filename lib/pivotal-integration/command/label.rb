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
require_relative '../util/label'
require 'pivotal-tracker'

MODES = %w(add remove list once)

# The class that encapsulates starting a Pivotal Tracker Story
class PivotalIntegration::Command::Label < PivotalIntegration::Command::Base
  desc "Manage labels for the current story"

  # Adds labels for active story.
  # @return [void]
  def run(mode, *labels)
    abort "You need to specify mode first [#{MODES}], e.g. 'git label add to_qa'" unless MODES.include? mode

    PivotalIntegration::Util::Label.send(mode, story, *labels)
  end
end
