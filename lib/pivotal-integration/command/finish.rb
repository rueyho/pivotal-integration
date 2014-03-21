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

# The class that encapsulates finishing a Pivotal Tracker Story
class PivotalIntegration::Command::Finish < PivotalIntegration::Command::Base
  desc "Finish working on a story"

  # Finishes a Pivotal Tracker story by doing the following steps:
  # * Check that the pending merge will be trivial
  # * Merge the development branch into the root branch
  # * Delete the development branch
  # * Push changes to remote
  #
  # @return [void]
  def run(*arguments)
    no_complete = arguments.delete('--no-complete')
    no_delete = arguments.delete('--no-delete')
    no_merge = arguments.delete('--no-merge')
    pull_request = arguments.delete('--pull-request') || PivotalIntegration::Util::Git.finish_mode == :pull_request

    if pull_request
      PivotalIntegration::Util::Git.push PivotalIntegration::Util::Git.branch_name
      PivotalIntegration::Util::Git.create_pull_request(@configuration.story)
      PivotalIntegration::Util::Story.mark(@configuration.story, :finished)
      return
    end

    unless no_merge
      PivotalIntegration::Util::Git.trivial_merge?
      PivotalIntegration::Util::Git.merge(@configuration.story, no_complete, no_delete)
    end

    PivotalIntegration::Util::Git.push PivotalIntegration::Util::Git.branch_name
  end

end
