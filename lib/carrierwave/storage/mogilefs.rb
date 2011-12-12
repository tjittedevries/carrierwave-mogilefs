# encoding: utf-8
require 'carrierwave'

begin
  require 'mogilefs'
rescue LoadError
  raise "You don't have the 'mogilefs-client' gem installed."
end

module CarrierWave
  module Storage

    ##
    #
    #     CarrierWave.configure do |config|
    #       config.mogilefs_domain = 'my.mogileserver.com'
    #       config.mogilefs_hosts = [10.0.0.1:7001,10.0.0.2:7001]
    #     end
    #
    #
    class Mogilefs < Abstract
      
      class File

        def initialize(uploader, base, path)
          @uploader = uploader
          @path = path
          @base = base

          # Starting connection, using mogilefs-client
          @mg = MogileFS::MogileFS.new(:domain => mogilefs_domain, :hosts => mogilefs_hosts)
        end

        ##
        # Returns the current path/filename of the file on Cloud Files.
        #
        # === Returns
        #
        # [String] A path
        #
        def path
          @path
        end

        ##
        # Reads the contents of the file from Cloud Files
        #
        # === Returns
        #
        # [String] contents of the file
        #
        def read
        end

        ##
        # Remove the file from Cloud Files
        #
        def delete
        end

        ##
        # Returns the url on the Cloud Files CDN.  Note that the parent container must be marked as
        # public for this to work.
        #
        # === Returns
        #
        # [String] file's url
        #
        def url
        end

        ##
        # Writes the supplied data into the object on Cloud Files.
        #
        # === Returns
        #
        # boolean
        #
        def store(data,headers={})
        end

        private

      end

      ##
      # Store the file on UpYun
      #
      # === Parameters
      #
      # [file (CarrierWave::SanitizedFile)] the file to store
      #
      # === Returns
      #
      # [CarrierWave::Storage::UpYun::File] the stored file
      #
      def store!(file)
        f = CarrierWave::Storage::Mogilefs::File.new(uploader, self, uploader.store_path)
        f.store(file.read, file.content_type)
        f
      end

      # Do something to retrieve the file
      #
      # @param [String] identifier uniquely identifies the file
      #
      # [identifier (String)] uniquely identifies the file
      #
      # === Returns
      #
      # [CarrierWave::Storage::UpYun::File] the stored file
      #
      def retrieve!(identifier)
        CarrierWave::Storage::Mogilefs::File.new(uploader, self, uploader.store_path(identifier))
        #CarrierWave::Storage::UpYun::File.new(uploader, self, uploader.store_path(identifier))
      end


    end # CloudFiles
  end # Storage
end # CarrierWave
