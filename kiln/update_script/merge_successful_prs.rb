require "octokit"

# Full name of the repo you want to create pull requests for.
repo_name = ENV["DEPENDABOT_TARGET_REPO"] # namespace/project
repo_branch = ENV["DEPENDABOT_TARGET_REPO_BRANCH"]
pr_username = "releen"

client = Octokit::Client.new(:login => 'x-access-token', :password => ENV["GITHUB_RELENG_CI_BOT_PERSONAL_ACCESS_TOKEN"])

pull_requests = client.pull_requests(repo_name, :state => 'open', :base => repo_branch)

pull_requests.each do |pull|
  next unless pr_username.eql?(pull.user.login)
  puts "Checking status of #{pull.title}"
  status = client.combined_status(repo_name, pull.head.ref)
  puts status.state
  if status.state == "success"
    puts "Merging #{pull.title}"
    client.merge_pull_request(repo_name, pull.number, commit_message = '', :merge_method => 'rebase')
  end
end
