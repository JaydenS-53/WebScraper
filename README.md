# WebScraper

Overview
WebScraper is a Ruby project that allows users to input a website URL, scrape information from the website, and display various details such as IP address, email addresses, physical addresses, social media accounts, HTTP response headers, images, robots.txt, phone numbers, links, headers, and dates.

Prerequisites
Ruby installed on your machine.
Required Ruby gems: net/http, nokogiri, and tk.

Install them using:
gem install net-http
gem install nokogiri

Usage
Clone the repository:
git clone https://github.com/your-username/website_scraper.git

Navigate to the project directory:
cd website_scraper

Run the application:
ruby website_scraper.rb

Enter the website URL when prompted.

Features
Website Information: Extracts and displays the IP address of the website.
Email Addresses: Scans and displays unique email addresses found on the website.
Physical Addresses: Searches and displays physical addresses found on the website.
Postcodes: Searches and displays US and UK postcodes found on the website.
Social Media Accounts: Identifies and displays links to social media accounts related to the website.
HTTP Response Headers: Displays the HTTP response headers.
Images: Lists the URLs of images found on the website.
robots.txt: Fetches and displays the contents of the robots.txt file.
Phone Numbers: Extracts and displays unique phone numbers found on the website.
Links: Lists the URLs of links found on the website.
Headers: Displays headers of different levels (H1, H2, H3, H4, H5) found on the website.
Dates: Finds and displays dates mentioned on the website.
GUI Interface
The application provides a simple GUI interface using the Tk library for user interaction. Users can enter the website URL, click the "Scrape Website" button, and view the extracted information in the output area.
