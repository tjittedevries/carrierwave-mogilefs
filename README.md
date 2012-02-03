# MogileFS Storage Adapter for CarrierWave

This gem adds support for [MogileFS Storage](http://www.mogilefs.org) to [CarrierWave](https://github.com/jnicklas/carrierwave/)

## Installation

    gem install carrierwave-mogilefs

## Using Bundler

    gem 'mogilefs-client', '~> 3.0'
    gem 'carrierwave-mogilefs', :require => "carrierwave/mogilefs"

## Configuration

Add the following configuration to a carrierwave initializer ( config/initializes/carrierwave.rb )

```ruby
CarrierWave.configure do |config|
  config.storage = :mogilefs
  config.mogilefs_hosts = ['10.0.0.1:7001', '10.0.0.2:7001']
  config.mogilefs_domain = "my.mogilefs.com"
  config.mogilefs_class = "photo"
end
```

And then in your uploader, set the storage to `:mogilefs`:

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :mogilefs
end
```

