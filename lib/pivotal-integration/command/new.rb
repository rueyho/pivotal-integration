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

# The class that encapsulates starting a Pivotal Tracker Story
class PivotalIntegration::Command::New < PivotalIntegration::Command::Base
  desc "Create a new story"

  STORY_TYPES = %w(feature bug chore release)
  def run(*arguments)
    options = self.class.collect_type_and_name(arguments)

    puts
    print 'Creating new story on Pivotal Tracker... '
    PivotalIntegration::Util::Story.new(@configuration.project, *options)
    puts 'OK'
  end

  class << self
    def collect_type_and_name(arguments)
      type = STORY_TYPES.include?(arguments.first.try(:downcase)) ? arguments.shift : choose_type
      type = type.downcase.to_sym

      name = arguments.shift || ask('Provide a name for the new story: ')

      [name, type]
    end

  private

    def choose_type
      choose do |menu|
        menu.prompt = 'What type of story do you want to create: '
        STORY_TYPES.each { |type| menu.choice(type.titleize) }
      end
    end
  end
end
