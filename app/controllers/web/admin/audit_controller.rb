class Web::Admin::AuditController < Web::Admin::ApplicationController
  authorize_actions_for Audit

  def index
    @audits = Audit.all.order(created_at: :desc)
  end
end
