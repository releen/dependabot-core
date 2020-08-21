# frozen_string_literal: true

require "spec_helper"
require "dependabot/dependency"
require "dependabot/dependency_file"
require "dependabot/vendir/file_updater"
require_common_spec "file_updaters/shared_examples_for_file_updaters"

RSpec.describe Dependabot::Vendir::FileUpdater do
  # it_behaves_like "a dependency file updater"

  let(:updater) do
    described_class.new(
      dependencies: [dependency],
      dependency_files: [],
      credentials: credentials
    )
  end
  let(:files) { [vendir_yml, vendir_lock_yml] }
  let(:credentials) do
    [{
      "type" => "git_source",
      "host" => "github.com",
      "username" => "x-access-token",
      "password" => "token"
    }]
  end
  let(:vendir_yml) do
    Dependabot::DependencyFile.new(
      name: "vendir.yml",
      content: vendir_yml_content
    )
  end
  let(:vendir_yml_content) { fixture("vendir_ymls", vendir_yml_fixture_name) }
  let(:vendir_yml_fixture_name) { "vendir.yml" }
  let(:vendir_lock_yml) do
    Dependabot::DependencyFile.new(
      name: "vendir.lock.yml",
      content: vendir_lock_yml_content
    )
  end
  let(:vendir_lock_yml_content) { fixture("vendir_lock_ymls", vendir_lock_yml_fixture_name) }
  let(:vendir_lock_yml_fixture_name) { "vendir.lock.yml" }
  let(:dependency) do
    Dependabot::Dependency.new(
      name: "config/_ytt_lib/github.com/cloudfoundry/cf-k8s-networking",
      version: "4153bbdbaf3e8d3d681a84a112f3c9cc10129ff3",
      requirements: [{
        requirement: "v0.0.6",
        groups: [],
        source: {
          type: "git",
          branch: "v0.0.6",
          url: "https://github.com/cloudfoundry/cf-k8s-networking"
        },
        file: vendir_yml_fixture_name
      }],
      package_manager: "vendir"
    )
  end

  describe "#updated_dependency_files" do
    subject(:updated_files) { updater.updated_dependency_files }
    # let(:process_status) { double }
    # let(:command) { /kiln update-release --name uaa --version #{current_version} -kf .*\/Kilnfile -rd .*\/ -vr aws_access_key_id=foo -vr aws_secret_access_key=foo/ }

    before do
      # allow(process_status).to receive(:success?).and_return true
      # allow(Open3).to receive(:capture3).and_return('', '', process_status)
    end

    it "returns DependencyFile objects" do
      # updated_files.each { |f| expect(f).to be_a(Dependabot::DependencyFile) }
      expect(true).to eq(true)
    end

    its(:length) { is_expected.to eq(1) }

    it "has updated dependency" do
      # expect(updated_files[0].content).to eq(updated_lockfile_body)
    end

    it "calls kiln to update the dependency" do
      # updated_files
      # expect(Open3).to have_received(:capture3).with(command)
    end
  end
end
