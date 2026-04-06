require 'csv'
require 'octokit'
require 'time'

# Use environment variables for security! 
# e.g., export GITHUB_TOKEN="your_new_token" in your terminal
TOKEN = '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' 

# Note: Octokit usually expects the format 'owner/repo' (e.g., 'octocat/ruby-test')
REPO = 'ruby-test' 
OUTPUT = 'output.csv'

client = Octokit::Client.new(access_token: TOKEN)
client.auto_paginate = true

begin
  puts "Fetching closed pull requests..."
  # Fetch all closed pull requests
  closed_prs = client.pull_requests(REPO, state: 'closed')

  CSV.open(OUTPUT, 'w', write_headers: true, headers: ['Author', 'Title', 'Created At', 'Merged At', 'Duration (Seconds)', 'Additions', 'Deletions']) do |csv|
    
    closed_prs.each do |pr|
      # Skip PRs that were closed without being merged
      next if pr.merged_at.nil?

      # The standard list endpoint doesn't include additions/deletions.
      # We must fetch the individual detailed PR object to get those stats.
      detailed_pr = client.pull_request(REPO, pr.number)

      # Octokit automatically returns Time objects, no need to parse
      created_at = pr.created_at
      merged_at = pr.merged_at
      duration_seconds = merged_at - created_at

      # Write row to CSV
      csv << [
        pr.user.login,
        pr.title,
        created_at,
        merged_at,
        duration_seconds.to_i, # .to_i rounds it to whole seconds
        detailed_pr.additions,
        detailed_pr.deletions
      ]
      
      puts "Processed PR ##{pr.number} - #{pr.title}"
    end
  end

  puts "Data successfully written to #{OUTPUT}"

rescue Octokit::Error => e
  puts "GitHub API Error: #{e.message}"
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
