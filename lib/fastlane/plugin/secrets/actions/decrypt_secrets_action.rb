require 'fastlane/action'
require 'mobile-secrets'

module Fastlane
  module Actions
    class DecryptSecretsAction < Action
      def self.run(params)
        secrets_path = params[:file_path]
        password = params[:password]
        empty = params[:empty]
        private_key_path = params[:private_key_path]
        target_path = "#{Dir.pwd}/#{params[:target_path]}/secrets.swift"
        tmp_decrypted_secrets_file = "/tmp/secrets"
        secrets_handler = MobileSecrets::SecretsHandler.new

        return secrets_handler.inject_secrets [[]], target_path if empty


        clean tmp_decrypted_secrets_file
        if private_key_path && password
          sh("gpg", "-v", "--pinentry-mode", "loopback", "--passphrase", password, "--import", private_key_path)
          sh("gpg", "-a", "--pinentry-mode", "loopback", "--passphrase", password, "--output", tmp_decrypted_secrets_file, "--decrypt", secrets_path)
        elsif password then
          sh("gpg", "-a", "--pinentry-mode", "loopback", "--passphrase", password, "--output", tmp_decrypted_secrets_file, "--decrypt", secrets_path)
        else
          sh("gpg", "--output", tmp_decrypted_secrets_file, "--decrypt", secrets_path)
        end

        yml_config = File.read tmp_decrypted_secrets_file
        bytes = secrets_handler.process_yaml_config yml_config
        secrets_handler.inject_secrets bytes, target_path
        clean tmp_decrypted_secrets_file
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

      def self.clean file_path
        File.delete(file_path) if File.exist?(file_path)
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :file_path,
                                       description: "Path to the encrypted secrets file",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :target_path,
                                       description: "Output path for the auto generated source file",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :password,
                                       description: "Password to open the GPG secrets file",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :private_key_path,
                                       description: "Path to a private key for GPG",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :empty,
                                       description: "Path to a private key for GPG",
                                       type: Boolean,
                                       optional: true,
                                       default_value: false)
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
