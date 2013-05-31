# encoding: utf-8
require 'carrierwave'

begin
  require 'mogilefs'
rescue LoadError
  raise "You don't have the 'mogilefs-client' gem installed."
end

module CarrierWave
  module Storage

    #  CarrierWave.configure do |config|
    #    config.mogilefs_domain = 'my.mogileserver.com'
    #    config.mogilefs_hosts = [10.0.0.1:7001,10.0.0.2:7001]
    #    config.mogilefs_timout = 5
    #  end
    #
    #  !! content class 'avatar' must exist in MogileFS !!
    #  TODO: replace static class with configurable class per uploader

    class Mogilefs < Abstract
      
      class File

        def initialize(uploader, base, key)
          @uploader = uploader
          @key = key
          @base = base

          @mogilefs_domain = @uploader.mogilefs_domain
          @mogilefs_hosts = @uploader.mogilefs_hosts
          @mogilefs_folder = @uploader.mogilefs_folder
          @mogilefs_class = @uploader.mogilefs_class
          @mogilefs_timeout = @uploader.mogilefs_timeout
          
          connection_options = {:domain => @mogilefs_domain, :hosts => @mogilefs_hosts}
          
          connection_options[:timeout] = @mogilefs_timeout if @mogilefs_timeout

          # Starting connection, using mogilefs-client
          @mg = MogileFS::MogileFS.new(connection_options)
        end

        # MogileFS supports no path, so key of the file is returned
        # aliased in key()
        # @return [String] key
        def path
          @key
        end

        # Reads the contents of the file from MogileFS for key
        # @return [String] content of the file
        def read
          begin
            @mg.get_file_data(@key)
          rescue => e
            puts "read error: #{e.inspect}, key: #{@key}"
            ''
          end
        end

        # Remove the file from MogileFS for key
        # @return [Boolean]
        def delete
          begin
            @mg.delete(@key)
            true
          rescue => e
            puts "delete error: #{e.inspect}, key: #{@key}"
            false
          end
        end
        
        def content_type
          ''
        end

        # Return a fake URL to file
        # example: /uploads/user/avatars/1/image.png
        # use /uploads/ to filter request to MogileFS backend
        # use user/avatar/1/image.png as key to MogileFS backend
        # 
        # For Nginx use: http://www.grid.net.ru/nginx/mogilefs.en.html 
        #
        # @return [String] url to file
        def url
          "#{@mogilefs_folder}/#{@key}"
        end

        # Writes the supplied data into an object in MogileFS
        # path is used as key in MogileFS
        # @return [Boolean]
        def store(file)
          @mg.store_file(@key, @mogilefs_class, file.file)
        end

      end

      # Store the file in MogileFS
      # @param [CarrierWave::SanitizedFile] the file to store
      # @return [CarrierWave::Storage::Mogilefs::File] the stored file
      def store!(file)
        f = CarrierWave::Storage::Mogilefs::File.new(uploader, self, uploader.store_path)
        f.store(file)
        f
      end

      # Do something to retrieve the file
      # @param [String] identifier uniquely identifies the file (key)
      # @return [CarrierWave::Storage::Mogilefs::File] the stored file
      def retrieve!(identifier)
        f = CarrierWave::Storage::Mogilefs::File.new(uploader, self, uploader.store_path(identifier))
        f.read
        f
      end

    end # Mogilefs
  end # Storage
end # CarrierWave
