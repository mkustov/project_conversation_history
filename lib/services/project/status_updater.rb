# frozen_string_literal: true

module Services
  module Project
    class StatusUpdater
      def initialize(project:, user:, from_status:, to_status:)
        @project = project
        @user = user
        @from_status = from_status
        @to_status = to_status
      end

      def call
        ActiveRecord::Base.transaction do
          update_project_status
          create_status_change
        end
      rescue StandardError
        false
      end

      private

      attr_reader :project, :user, :from_status, :to_status

      def update_project_status
        project.update!(status: to_status)
      end

      def create_status_change
        StatusChange.create!(project: project, user: user, from_status: from_status, to_status: to_status)
      end
    end
  end
end
