require 'net/http'
require 'nokogiri'
require 'tk'

# Define the function to perform scraping
def scrape_website
  user_input = $entry.get
  url = URI.parse(user_input)
  response = Net::HTTP.get_response(url)

  if response.code == '200'
    html_content = response.body
    doc = Nokogiri::HTML(html_content)

    # Extract headers
    h1 = doc.css('h1').map { |h1| h1.text }
    h2 = doc.css('h2').map { |h2| h2.text }
    h3 = doc.css('h3').map { |h3| h3.text }
    h4 = doc.css('h4').map { |h4| h4.text }
    h5 = doc.css('h5').map { |h5| h5.text }
 
    # Update the output area with headers
    $output.value = "H1 Headers:\n#{h1.join("\n")}\n\n"
    $output.value += "H2 Headers:\n#{h2.join("\n")}\n\n"
    $output.value += "H3 Headers:\n#{h3.join("\n")}\n\n"
    $output.value += "H4 Headers:\n#{h4.join("\n")}\n\n"
    $output.value += "H5 Headers:\n#{h5.join("\n")}"

    # add links to output
    links = doc.css('a').map { |link| link['href'] }
    $output.value = links.join("\n")
  else
    $output.value = "Error: #{response.code} #{response.message}"
  end
end

# Create the main application window
root = TkRoot.new { title "Website Scraper" }

# Create an input field
$entry = TkEntry.new(root) { pack }

# Create a button to trigger scraping
TkButton.new(root) {
  text "Scrape Website"
  command proc { scrape_website }
  pack
}

# Create an output area to display links
$output = TkText.new(root) {
  width 150
  height 150
  wrap 'word'
  pack
}

# Start the Tk event loop
Tk.mainloop
