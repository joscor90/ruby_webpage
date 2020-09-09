require "uri"
require "net/http"
require "openssl"
require "json"

def request(url, api_key)

    #Request to NASA API
    url = URI("#{url}&api_key=#{api_key}")
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    data = response.read_body

    #Parsing data 
    data = JSON.parse(data)

    
    #Output hash
    output_hash = {MAST: [], FHAZ: [], RHAZ: [], CHEMCAM: [], NAVCAM: [], MAHLI: [], MARDI: [], PAMCAM: [], MINITES: []}
    data["photos"].each do |ele|
        ele.each do |k, v|
           if k == "camera"
                case v["name"]
                when "MAST"
                    output_hash[:MAST].push(ele["img_src"])
                when "FHAZ"
                    output_hash[:FHAZ].push(ele["img_src"])
                when "RHAZ"
                    output_hash[:RHAZ].push(ele["img_src"])
                when "CHEMCAM"
                    output_hash[:CHEMCAM].push(ele["img_src"])
                when "NAVCAM"
                    output_hash[:NAVCAM].push(ele["img_src"])
                when "MAHLI"
                    output_hash[:MAHLI].push(ele["img_src"])
                when "MARDI"
                    output_hash[:MARDI].push(ele["img_src"])
                when "PAMCAM"
                    output_hash[:PAMCAM].push(ele["img_src"])
                when "MINITES"
                    output_hash[:MINITES].push(ele["img_src"])
                end
           end
        end
    end
    return output_hash
end

#build_web_page method
def build_web_page(output_hash)
    head = "<html>\n\t<head>\n\t\t\t<title>NASA PHOTOS</title>\n\t</head>\n\t<body>\n"
    body = "\t\t<ul>"
    footer = "\t\t</ul>\n\t</body>\n</html>"
    output_hash.each do |k, v|
        v.each do |i|
            body += "\n\t\t\t<li><img src=\"#{i}\">...</img>\n"
        end
    end
    return head+body+footer
end




info = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000","p4qrdNNDbxlw2IKbyoVbO41EFviwWAAApE6Bk9E7")


test = build_web_page(info)
File.write("index.html", test)