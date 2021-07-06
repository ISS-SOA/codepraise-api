# frozen_string_literal: true

module CodePraise
  module Value
    # Contributions for a folder of a project
    ProjectFolderContributions = Struct.new(:project, :folder, :commits)
  end
end
