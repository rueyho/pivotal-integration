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

# The class that encapsulates starting a Pivotal Tracker Story
class PivotalIntegration::Command::Estimate < PivotalIntegration::Command::Base
  desc "Assign an estimate to the current story"

  def run(*arguments)
    score = arguments.first

    unless score
      case story.estimate
      when -1
        puts "Story is currently unestimated."
      else
        puts "Story is currently estimated #{story.estimate}."
      end

      score = self.class.collect_estimation(@configuration.project)
    end

    case score
      when -1
        print 'Changing to unestimated... '
      else
        print "Changing estimation to #{score}... "
    end

    PivotalIntegration::Util::Story.estimate(story, score)
    puts 'OK'
  end

  def self.collect_estimation(project)
    possible_scores = project.point_scale.split(',')
    score = -1
    score = ask("Choose an estimation for this story [#{possible_scores.join(', ')}, enter for none]: ") until possible_scores.include?(score) or score.blank?
    score.blank? ? -1 : score
  end
end
