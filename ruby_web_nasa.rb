require "uri"
require "net/http"
require "openssl"
require "json"


#request method
def request(url, api_key)
    url = URI("#{url}&api_key=#{api_key}")
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    puts response.read_body
end

data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10","p4qrdNNDbxlw2IKbyoVbO41EFviwWAAApE6Bk9E7") 

print "#{data}\n"

