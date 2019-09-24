require 'fastlane/action'
require_relative '../helper/secrets_helper'

module Fastlane
  module Actions
    class SecretsAction < Action
      def self.run(params)
        list = params[:key_value_list]
        salt = params[:salt]
        target_path = params[:target_path]

        bytes = [salt.bytes]

        list.each do |key, value|
          encrypted = Helper::SecretsHelper.xor_chiper(salt, value)
          bytes << key.bytes << encrypted.bytes
        end

        Helper::SecretsHelper.inject_secrets(bytes, "#{target_path}/Secrets.swift")
      end

      def self.description
        "Securely store secrets in source code"
      end

      def self.authors
        ["Cyril Cermak, Jörg Nestele"]
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :key_value_list,
                                       description: "List of key-value pairs to be obfuscated",
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :salt,
                                       description: "Salt key that is used as passphrase for the XOR chiper",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :target_path,
                                       description: "Path of the auto-generated Secrets.swift file",
                                       is_string: true)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
