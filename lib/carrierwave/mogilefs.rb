require "carrierwave/storage/mogilefs"
require "carrierwave/mogilefs/configuration"
CarrierWave.configure do |config|
  config.storage_engines.merge!({:mogilefs => "CarrierWave::Storage::Mogilefs"})
end

CarrierWave::Uploader::Base.send(:include, CarrierWave::Mogilefs::Configuration)
