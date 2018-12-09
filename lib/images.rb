require 'open-uri'

module Tools
  class Images
    class << self
      def temp_file(url)
        path = "./files/#{generate_name}"
        file = File.open(path, 'wb')
        file.write open(url).read
        file.close
        file
      end

      def generate_name
        'image_' + Time.now.to_s.gsub(/[^0-9]/, '') + '.jpg'
      end
    end
  end
end
