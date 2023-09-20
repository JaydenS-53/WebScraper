require 'net/http'
require 'nokogiri'

# Step 1: Make an HTTP Request
puts "Please enter website to scrape: "
user_input = gets.chomp
url = URI.parse(user_input)  
response = Net::HTTP.get_response(url)

# Check if the response is successful (HTTP status 200)
if response.code == '200'
  html_content = response.body
else
  puts "Error: #{response.code} #{response.message}"
  exit
end

# Step 2: Parse the HTML Content
doc = Nokogiri::HTML(html_content)
# Now, you can use Nokogiri methods to navigate and extract data from the HTML
# For example, to get all the links on the page:

links = doc.css('a').map { |link| link['href'] }

h1 = doc.css('h1').map { |h1| h1.text }
h2 = doc.css('h2').map { |h2| h2.text }
h3 = doc.css('h3').map { |h3| h3.text }
h4 = doc.css('h4').map { |h4| h4.text }
h5 = doc.css('h5').map { |h5| h5.text }

# Print out the extracted data
# puts h1
puts links
