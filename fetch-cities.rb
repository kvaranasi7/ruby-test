require("HTTParty")
require("json")

response = HTTParty.get('https://jsonplaceholder.typicode.com/users')

data=response.parsed_response
filter = data.select { |item| item['address']['city'].start_with?('S') }


filter.each do |item|
	puts "Name: #{item['name']}"
	puts "City: #{item['address']['city']}"

end
