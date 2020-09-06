require "uri"
require "net/http"
require "openssl"
require "json"


#request method
def request(url, api_key)

    #request to NASA API
    url = URI("#{url}&api_key=#{api_key}")
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    data = response.read_body

    #Parsing data 
    data = JSON.parse(data)

    #Output generation
    output_hash = {}
    data["photos"].each do |ele|
        i = data["photos"].index(ele)
        ele.each do |k, v|
            if k == "img_src"
                output_hash[i] = v
            end
        end
    end
    return output_hash 
end

#build_web_page method
def build_web_page(output_hash)
    head = "!DOCTYPE html\n<html>\n\t<head>\n\t</head>\n\t<body>\n"
    count = output_hash.length
    body = "\t\t<ul>"
    footer = "\t\t</ul>\n\t</body>\n</html>"
    output_hash.each do |k, v|
        body += "\n\t\t\t<li><img src=\"#{v}\">...</img>\n"
    end
    return head+body+footer
end


info = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10","p4qrdNNDbxlw2IKbyoVbO41EFviwWAAApE6Bk9E7") 

# print "#{info}"

test = build_web_page(info)

print "#{test}"