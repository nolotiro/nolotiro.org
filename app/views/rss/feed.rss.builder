xml.instruct! :xml, :version => "1.0"
xml.rss version: "2.0", "xmlns:media" => "http://search.yahoo.com/mrss/", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "nolotiro.org"
    xml.description t('nlt.footer_explain')
    xml.link "http://nolotiro.org/"

    @ads.each do |ad|
      xml.item do
        xml.title ad.title
        description =  ad.body
        if ad.image?
          description = image_tag(
            request.protocol + request.host_with_port + ad.image.url(:thumb), :style => "float:left;"
          ) + description
        end
        xml.description description 
        xml.pubDate ad.created_at.to_s(:rfc822)
        xml.link ad_url(ad)
        xml.guid ad_url(ad)
      end
    end
  end
end
