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
class PivotalIntegration::Command::Comment < PivotalIntegration::Command::Base
  desc "Add a comment to the current story"

  def run(*arguments)
    comment = arguments.first
    abort "A comment must be provided." unless comment

    print "Adding comment to story ##{story.id}... "
    PivotalIntegration::Util::Story.add_comment(story, comment)
    puts 'OK'
  end
end
