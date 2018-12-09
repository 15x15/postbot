require 'open-uri'

module Tools
  class Images
    class << self
      def temp_file(url)
        file = File.open(img_path, 'wb')
        file.write open(url).read
        file.close
        file
      end

      def generate_name
        'image_' + Time.now.to_s.gsub(/[^0-9]/, '') + '.jpg'
      end

      def img_path
        root_path = File.realpath(__dir__)
        root_path.slice! 'lib'
        root_path + "files/#{generate_name}"
      end
    end
  end
end
