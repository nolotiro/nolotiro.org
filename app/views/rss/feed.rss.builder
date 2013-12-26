xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "nolotiro.org"
    xml.description t('nlt.footer_explain')
    xml.link "http://nolotiro.org/"

    @ads.each do |ad|
      xml.item do
        xml.title ad.title
        if ad.image?
          xml.image "http://nolotiro.org/" + ad.image.url
        end
        description =  ad.body
        xml.description description
        xml.pubDate ad.created_at.to_s(:rfc822)
        xml.link ad_url(ad)
        xml.guid ad_url(ad)
      end
    end
  end
end
