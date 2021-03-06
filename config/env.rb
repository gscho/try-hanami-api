require 'bundler'
APP_ENV = ENV["RACK_ENV"] || "development"

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

Bundler.require :default, APP_ENV

path = File.expand_path '../../', __FILE__
PATH = path
DOCKER = ENV["DOCKER"]

# faster json serialization (Oj.dump // Oj.load)
Oj.default_options = { mode: :compat }

# setup redis
REDIS_HOST = DOCKER == "1" ? "db" : "localhost"
redis_config = { db: 0, host: REDIS_HOST }
R = Redis.new redis_config
# R.flushdb if APP_ENV == "development" # && ENV["RESET_REDIS"] == "1"

# configure rejson models
include RedisRejsonModels
RJ.configure redis: R

# require your libs/models here
#
# require_relative '../lib/file'

require_relative '../models/phrase'
