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
    #     !! content class 'avatar' must exist in MogileFS !!
    #     TODO: replace static class with configurable class per uploader
    #
    class Mogilefs < Abstract
      
      class File

        def initialize(uploader, base, key)
          @uploader = uploader
          @key = key
          @base = base

          @mogilefs_domain = @uploader.mogilefs_domain
          @mogilefs_hosts = @uploader.mogilefs_hosts

          # Starting connection, using mogilefs-client
          @mg = MogileFS::MogileFS.new(:domain => @mogilefs_domain, :hosts => @mogilefs_hosts)
        end

        ##
        # Returns the key of the file in MogileFS
        #
        # === Returns
        #
        # [String] file's key
        #
        def path
          @key
        end

        ##
        # Reads the contents of the file from MogileFS for given key
        #
        # === Returns
        #
        # [String] file's content
        #
        def read
          begin
            @mg.get_file_data(@key)
          rescue => e
            puts "error: #{e.inspect}"
            ''
          end
        end

        ##
        # Remove the file from MogileFS for key
        #
        def delete
          begin
            @mg.delete(@key)
          rescue => e
            puts "error: #{e.inspect}"
            ''
          end
        end

        ##
        # Object has no URL in MogileFS, instead return key of the file.
        #
        # === Returns
        #
        # [String] file's content
        #
        def url
          @key
        end

        ##
        # Writes the supplied data into an object in MogileFS
        # filename/path is used as key in MogileFS
        #
        # === Returns
        #
        # boolean
        #
        def store(file)
          @mg.store_file(@key, 'avatar', file.file)
        end

        private

      end

      ##
      # Store the file in MogileFS
      #
      # === Parameters
      #
      # [file (CarrierWave::SanitizedFile)] the file to store
      #
      # === Returns
      #
      # [CarrierWave::Storage::Mogilefs::File] the stored file
      #
      def store!(file)
        f = CarrierWave::Storage::Mogilefs::File.new(uploader, self, uploader.store_path)
        f.store(file)
        f
      end

      # Do something to retrieve the file
      #
      # @param [String] identifier uniquely identifies the file (key)
      #
      # [identifier (String)] uniquely identifies the file (key)
      #
      # === Returns
      #
      # [CarrierWave::Storage::Mogilefs::File] the stored file
      #
      def retrieve!(identifier)
        f = CarrierWave::Storage::Mogilefs::File.new(uploader, self, uploader.store_path(identifier))
        f.read
        f
      end

    end # Mogilefs
  end # Storage
end # CarrierWave
