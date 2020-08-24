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
      dependency_files: files,
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
        requirement: "v0.0.7",
        groups: [],
        source: {
          type: "git",
          branch: "v0.0.7",
          url: "https://github.com/cloudfoundry/cf-k8s-networking",
          path: ["config/_ytt_lib", "github.com/cloudfoundry/cf-k8s-networking"]
        },
        file: vendir_yml_fixture_name
      }],
      previous_requirements: [{
         requirement: "v0.0.6",
         groups: [],
         source: {
           type: "git",
           branch: "v0.0.6",
           url: "https://github.com/cloudfoundry/cf-k8s-networking",
           path: ["config/_ytt_lib", "github.com/cloudfoundry/cf-k8s-networking"]
         },
         file: vendir_yml_fixture_name
       }],
      package_manager: "vendir"
    )
  end

  describe "#updated_dependency_files" do
    subject(:updated_files) { updater.updated_dependency_files }
    let(:process_status) { double }
    let(:command) { /vendir sync/ }

    let(:updated_lockfile_body) do
      fixture("vendir_lock_ymls", "updated_vendir.lock.yml")
    end

    before do
      allow(process_status).to receive(:success?).and_return(true)
      # allow(Open3).to receive(:capture3).with(command).and_return(['', '', process_status])
      updated_lockfile_context=updated_lockfile_body
      allow(Open3).to receive(:capture3).with(command) do
        # change vendir lock
        File.write("vendir.lock.yml", updated_lockfile_context)
        #allow(File).to receive(:read).with("spec/fixtures/vendir_lock_ymls/vendir.lock.yml").and_return(updated_lockfile_context)
        ['', '', process_status]
      end
    end

    it "has updated dependency" do
      expect(updated_files.length).to eq(2)
      expect(updated_files.first).to be_a(Dependabot::DependencyFile)
      expect(updated_files.last.name).to eq("vendir.lock.yml")
      expect(updated_files.last.content).to eq(updated_lockfile_body)
    end

 #   it "calls vendir to update the dependency" do
 #     updated_files
 #     expect(Open3).to have_received(:capture3).with(command)
 #   end
  end
end
