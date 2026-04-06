require 'httparty'
require 'json'

# Fetch data from the API
response = HTTParty.get('https://jsonplaceholder.typicode.com/posts')
posts  = response.parsed_response

id_posts  = posts.select { |posts| posts['userId'] == 1 }

id_posts.each do |post|
  puts "Title: #{post['title']}"
  puts "Body: #{post['body']}"
  puts "---"
end
