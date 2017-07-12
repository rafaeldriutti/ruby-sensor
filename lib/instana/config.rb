module Instana
  class Config

    def initialize
      @config = {}

      @config[:agent_host] = '127.0.0.1'
      @config[:agent_port] = 42699

      # Global on/off switch for prebuilt environments
      # Setting this to false will disable this gem
      # from doing anything.
      @config[:enabled] = true

      # Enable/disable metrics globally or individually (default: all enabled)
      @config[:metrics] = { :enabled => true }
      @config[:metrics][:gc]     = { :enabled => true }
      @config[:metrics][:memory] = { :enabled => true }
      @config[:metrics][:thread] = { :enabled => true }

      # Enable/disable tracing (default: enabled)
      @config[:tracing] = { :enabled => true }

      if ENV.key?('INSTANA_GEM_DEV')
        @config[:collector] = { :enabled => true, :interval => 3 }
      else
        @config[:collector] = { :enabled => true, :interval => 1 }
      end

      # EUM Related
      @config[:eum_api_key] = nil
      @config[:eum_baggage] = {}

      # Instrumentation
      @config[:action_controller]  = { :enabled => true }
      @config[:action_view]        = { :enabled => true }
      @config[:active_record]      = { :enabled => true }
      @config[:dalli]              = { :enabled => true }
      @config[:excon]              = { :enabled => true }
      @config[:nethttp]            = { :enabled => true }
      @config[:'rest-client']      = { :enabled => true }
      @config[:grpc]               = { :enabled => true }
      @config[:'sidekiq-client']   = { :enabled => true }
      @config[:'sidekiq-worker']   = { :enabled => true }
    end

    def [](key)
      @config[key.to_sym]
    end

    def []=(key, value)
      @config[key.to_sym] = value

      if key == :enabled
        # Configuring global enable/disable flag, then set the
        # appropriate children flags.
        @config[:metrics][:enabled] = value
        @config[:tracing][:enabled] = value
      end
    end
  end
end

::Instana.config = ::Instana::Config.new
