require 'httparty'
require 'json'

# Fetch data from the API
response = HTTParty.get('https://jsonplaceholder.typicode.com/todos')
todos = response.parsed_response

# Filter for incomplete todos only
incomplete = todos.select { |todo| todo['completed'] == false }

# Print a summary
puts "Total todos: #{todos.length}"
puts "Incomplete todos: #{incomplete.length}"
puts "---"

# Print first 5 incomplete todos
incomplete.first(5).each do |todo|
  puts "User #{todo['userId']}: #{todo['title']}"
end

# Save results to a file
File.open('results.json', 'w') do |f|
  f.write(JSON.pretty_generate(incomplete))
end

puts "---"
puts "Results saved to results.json"
