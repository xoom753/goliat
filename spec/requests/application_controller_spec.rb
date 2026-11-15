require "rails_helper"

RSpec.describe "ApplicationController client access restriction", type: :request do
  it "logs and rejects requests from non-permitted client IPs" do
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:remote_ip)
      .and_return("203.0.113.10")
    allow(Rails.logger).to receive(:info).and_call_original

    get root_path

    expect(response).to have_http_status(:service_unavailable)
    expect(response.body).to be_empty
    expect(Rails.logger).to have_received(:info).with("== Denied remote ip: 203.0.113.10")
  end
end
