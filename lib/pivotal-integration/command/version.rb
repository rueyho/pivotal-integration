class PivotalIntegration::Command::Version < PivotalIntegration::Command::Base
  desc "Show the version of this utility"

  def run(*arguments)
    puts PivotalIntegration::VERSION
  end
end