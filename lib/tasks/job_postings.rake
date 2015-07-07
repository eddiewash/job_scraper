desc "Grab product postings"

task fetch_postings: :environment do

  require 'nokogiri'
  require 'open-uri'

  url = "http://www.garysguide.com/jobs/product"
  doc = Nokogiri::HTML(open(url))
  Job.destroy_all
  doc.css(".boxx1 div:nth-child(2)").each do |job|
    title = job.at_css(".flarge a").text
    company = job.at_css(".fblack b").text
    link = job.at_css(".flarge a")[:href]
    Job.create title: title, company: company, link: "http://www.garysguide.com#{link}"
  end

end

# desc "Fetch product prices"
# task :fetch_prices => :environment do
#   require 'nokogiri'
#   require 'open-uri'

#   Product.find_all_by_price(nil).each do |product|
#     url = "http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=#{CGI.escape(product.name)}&Find.x=0&Find.y=0&Find=Find"
#     doc = Nokogiri::HTML(open(url))
#     price = doc.at_css(".PriceCompare .BodyS, .PriceXLBold").text[/[0-9\.]+/]
#     product.update_attribute(:price, price)
#   end
# end