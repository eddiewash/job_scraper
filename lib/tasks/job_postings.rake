desc "Grab product postings"

task fetch_postings: :environment do

  require 'nokogiri'
  require 'open-uri'

  Job.destroy_all

  url = "http://www.garysguide.com/jobs?type=full-time&category=product"
  doc = Nokogiri::HTML(open(url))
  doc.css(".boxx1 div:nth-child(2)").each do |job|
    title = job.at_css(".flarge a").text
    company = job.at_css(".fblack b").text
    link = job.at_css(".flarge a")[:href]
    origin = "GarysGuide"
    Job.create title: title, company: company, link: "http://www.garysguide.com#{link}", origin: origin
  end

  page = 1

  13.times do
    url2 = "http://www.glassdoor.com/Job/new-york-technical-project-manager-jobs-SRCH_IL.0,8_IC1132348_KO9,34_IP#{page}.htm"
    doc2 = Nokogiri::HTML(open(url2))
    doc2.css(".jobListing").each do |job|
      title = job.at_css(".jobLink").text
      company = job.at_css(".employerName strong").text
      link = job.at_css(".jobLink")[:href]
      origin = "Glassdoor"
      Job.create title: title, company: company, link: "http://www.glassdoor.com/#{link}", origin: origin
    end
    page += 1
  end

  page = 0

  86.times do
    url3 = "http://www.indeed.com/jobs?q=%22Product+Manager%22+OR+%22Technical+Project+Manager%22&l=New+York,+NY&sr=directhire&start=#{page}"
    doc3 = Nokogiri::HTML(open(url3))
    doc3.css(".result").each do |job|
        unless job.at_css(".company") == nil || job.at_css(".jobtitle")[:href] == nil
          origin = "Indeed"
          title = job.at_css(".jobtitle").text
          company = job.at_css(".company").text
          link = "http://www.indeed.com/" + job.at_css(".jobtitle")[:href]
          Job.create title: title, company: company, link: link, origin: origin
        end
    end
    page = page + 10
  end


  Job.all.each do |job|
    if job.company == "General Assembly"
      job.delete
    end
  end

end # end of task!





