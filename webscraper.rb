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
        $output.insert('end', "-------------------------------------------------------------------------------------------------------\n\n")
      end
    end

    # extract email addresses
    email_regex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b/
    email_addresses = html_content.scan(email_regex).uniq
    # add emails to output
    if !email_addresses.empty?
      $output.value += "Email Addresses:\n\n#{email_addresses.join("\n")}\n\n"
      $output.insert('end', "-------------------------------------------------------------------------------------------------------\n\n")
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
      $output.insert('end', "-------------------------------------------------------------------------------------------------------\n\n")
    end

    # extract links
    links = doc.css('a').map { |link| link['href'] }
    # add links to output
    if !links.empty?
      $output.value += "Links:\n\n#{links.join("\n")}\n\n"
      $output.insert('end', "-------------------------------------------------------------------------------------------------------\n\n")
    end
  else
    $output.value = "Error: #{response.code} #{response.message}"
  end

  social_media_platforms = {
    'Facebook' => 'facebook.com',
    'Twitter' => 'twitter.com',
    'Instagram' => 'instagram.com',
    'LinkedIn' => 'linkedin.com',
    'Github' => 'github.com'
    # Add more platforms as needed
  }

  social_media_accounts = {}

  social_media_platforms.each do |platform, domain|
    links = doc.css("a[href*='#{domain}']").map { |link| link['href'] }
    social_media_accounts[platform] = links unless links.empty?
  end

  # Update the output area with social media accounts
  social_media_accounts.each do |platform, accounts|
    $output.value += "#{platform} Accounts:\n\n#{accounts.join("\n")}\n\n"
    $output.insert('end', "-------------------------------------------------------------------------------------------------------\n\n")
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
