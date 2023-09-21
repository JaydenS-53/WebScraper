require 'net/http'
require 'nokogiri'
require 'tk'
require 'set'

# Define the function to perform scraping
def scrape_website
  user_input = $entry.get
  url = URI.parse(user_input)
  response = Net::HTTP.get_response(url)

  if response.code == '200'
    html_content = response.body
    doc = Nokogiri::HTML(html_content)

    # Get the IP address of the website
    ip_address = IPSocket.getaddress(url.host)

    # Add IP address to output
    $output.value += "Website IP Address:\n\n#{ip_address}\n\n"
    $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")

    # extract email addresses
    email_regex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b/
    email_addresses = html_content.scan(email_regex).uniq.reject do |email|
      email =~ /\.(jpeg|png)\b/
    end
    # add emails to output
    if !email_addresses.empty?
      $output.value += "Email Addresses:\n\n#{email_addresses.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

    # Search for physical addresses
    address_regex = /\b\d{1,5}\s\w+\s\w+,\s\w+\s\d{5}\b/
    addresses = html_content.scan(address_regex).uniq

    if !addresses.empty?
      $output.value += "Physical Addresses:\n\n#{addresses.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

    # Search for US and UK postcodes
    postcode_regex = /\b[A-Z]{1,2}\d{1,2}\s?\d[A-Z]{2}\b/
    postcodes = html_content.scan(postcode_regex).uniq

    if !postcodes.empty?
      $output.value += "Postcodes:\n\n#{postcodes.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

    social_media_platforms = {
      'Facebook' => 'facebook.com',
      'Twitter' => 'twitter.com',
      'Instagram' => 'instagram.com',
      'LinkedIn' => 'linkedin.com',
      'Github' => 'github.com',
      'Youtube' => 'youtube.com',
      'Reddit' => 'reddit.com',
      'Pinterest' => 'pinterest.com'
    }
  
    social_media_accounts = {}
  
    social_media_platforms.each do |platform, domain|
      links = doc.css("a[href*='#{domain}']").map { |link| link['href'] }
      social_media_accounts[platform] = links unless links.empty?
    end
  
    # Update the output area with social media accounts
    social_media_accounts.each do |platform, accounts|
      $output.value += "#{platform} Accounts:\n\n#{accounts.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

    headers = response.to_hash
    header_text = headers.map { |key, value| "#{key}: #{value.join(', ')}" }.join("\n")

    # Update the output area with headers
    $output.value += "HTTP Response:\n\n#{header_text}\n\n"
    $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")

    images = doc.css('img').map { |img| img['src'] }

    # Add images to output
    if !images.empty?
      $output.value += "Images:\n\n#{images.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

    # Fetch and display robots.txt
    robots_url = "#{url.scheme}://#{url.host}/robots.txt"
    robots_response = Net::HTTP.get_response(URI.parse(robots_url))

    if robots_response.code == '200'
      robots_content = robots_response.body
      $output.value += "robots.txt:\n\n#{robots_content}\n\n"
      $output.insert('end', "-------------------------------------------------------------------------------------------------------\n\n")
    else
      $output.value += "Error fetching robots.txt: #{robots_response.code} #{robots_response.message}\n\n"
    end

    unique_phone_numbers = Set.new

    # Extract phone numbers using regular expression
    phone_number_regex = /\b(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})\b/
    phone_numbers = html_content.scan(phone_number_regex).map { |match| match.compact.join('-') }
    
    # Add unique phone numbers to the set
    phone_numbers.each do |phone|
      unique_phone_numbers.add(phone)
    end

    # Add phone numbers to output
    if !unique_phone_numbers.empty?
      $output.value += "Phone Numbers:\n\n#{unique_phone_numbers.to_a.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

    # extract links
    links = doc.css('a').map { |link| link['href'] }
    # add links to output
    if !links.empty?
      $output.value += "Links:\n\n#{links.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

    # Extract headers
     h1 = doc.css('h1').map { |h1| h1.text }
     h2 = doc.css('h2').map { |h2| h2.text }
     h3 = doc.css('h3').map { |h3| h3.text }
     h4 = doc.css('h4').map { |h4| h4.text }
     h5 = doc.css('h5').map { |h5| h5.text }
  
     # Update the output area with headers
     [h1, h2, h3, h4, h5].each_with_index do |headers, index|
       if !headers.empty?
         level = index + 1
         $output.value += "H#{level} Headers:\n\n#{headers.join("\n")}\n\n"
         $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
       end
     end

     # Search for dates
    date_regex = /\b(?:\d{1,2}[\/\.-]\d{1,2}[\/\.-]\d{2,4}|\d{4}[\/\.-]\d{1,2}[\/\.-]\d{1,2})\b/
    dates = html_content.scan(date_regex).uniq

    if !dates.empty?
      $output.value += "Dates:\n\n#{dates.join("\n")}\n\n"
      $output.insert('end', "----------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    end

  else
    $output.value = "Error: #{response.code} #{response.message}"

  end

end

# Create the main application window
root = TkRoot.new { title "Website Scraper" }
root.configure(bg: 'black')

# Create an input field
$entry = TkEntry.new(root) { 
  width 50
  background 'white'
  font 'Helvetica 12'
  pack(pady: 10)
}

# Create a button to trigger scraping
TkButton.new(root) {
  text "Scrape Website"
  background 'white'
  foreground 'black'
  font 'Helvetica 12 bold'
  command proc { scrape_website }
  pady 10
  pack(pady: 10)
}

# Create an output area to display data
$output = TkText.new(root) {
  width 150
  height 40
  wrap 'word'
  background 'black'
  foreground 'white'
  pack
}

# Start the Tk event loop
Tk.mainloop
