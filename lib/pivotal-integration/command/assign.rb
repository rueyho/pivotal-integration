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
class PivotalIntegration::Command::Assign < PivotalIntegration::Command::Base
  desc "Assign the current story to a user"

  # Assigns story to user.
  # @return [void]
  def run(*arguments)
    username = arguments.first

    if username.nil? or !memberships.include?(username)
      username = choose_user
    end

    PivotalIntegration::Util::Story.assign(story, username)
  end

  private

  def choose_user
    choose do |menu|
      menu.prompt = 'Choose an user from above list: '

      memberships.each do |membership|
        menu.choice(membership)
      end
    end
  end

  def memberships
    @project.memberships.all.map(&:name)
  end
end
