# -*- coding: utf-8 -*-
require 'rubygems'
require 'rspec'
require 'rspec/autorun'
require 'rails'
require 'active_record'
require "carrierwave"
require 'carrierwave/orm/activerecord'
require 'carrierwave/processing/mini_magick'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "carrierwave/mogilefs"


module Rails
  class << self
    def root
      [File.expand_path(__FILE__).split('/')[0..-3].join('/'),"spec"].join("/")
    end
  end
end

ActiveRecord::Migration.verbose = false

CarrierWave.configure do |config|
  config.storage = :mogilefs
  config.mogilefs_hosts = ['33.33.33.10:7001']
  config.mogilefs_domain = 'brinellmogile'
end

def load_file(fname)
  File.open([Rails.root,fname].join("/"))
end
