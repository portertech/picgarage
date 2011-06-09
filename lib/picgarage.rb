require 'rubygems'
require 'json'
require 'curb'

module PicGarage

  class PicGarage

    def upload_image(image)

      if File.exists?(image)

        image_types = ["image/png", "image/x-png", "image/jpeg", "image/pjpeg", "image/gif"]

        file_options = RUBY_PLATFORM.downcase.include?("darwin") ? "-Ib" : "-ib"
        mime_type = `file #{file_options} #{image.gsub(/ /, "\\ ")}`.split(';').first

        if image_types.include? mime_type

          post = Curl::Easy.new("http://www.picgarage.net/uploader.json")
          post.multipart_form_post = true
          post.http_post(Curl::PostField.file("image", image))

          if post.response_code == 201

            response = JSON.parse(post.body_str)
            response["image"]["large_url"]

          else

            "Bad response from server, please try again."

          end

        else

          "Given image type is not accepted."

        end

      else

        "Given image does not exist."

      end

    end

  end

end
