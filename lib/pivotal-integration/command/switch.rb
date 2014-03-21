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
class PivotalIntegration::Command::Switch < PivotalIntegration::Command::Base
  desc "Switch the current story to another story"

  def run(*arguments)
    id = arguments.first

    if id == '-'
      previous_story = PivotalIntegration::Util::Git.get_config('pivotal.previous-story')
      abort "No previous story ID was set." unless previous_story.present?
      story = @configuration.project.stories.find(previous_story)
    else
      story = @configuration.project.stories.find(id)
      abort "A valid story ID must be provided." unless story
    end

    PivotalIntegration::Util::Git.set_config('pivotal.previous-story', @configuration.story.id)

    @configuration.story = story
    PivotalIntegration::Util::Story.pretty_print(story)

    # TODO: When switching stories, switch to the correct branch as well
    # TODO: Add post-checkout hook to switch to the correct story when changing branches
    # http://schacon.github.io/git/githooks.html#_post_checkout
  end
end
