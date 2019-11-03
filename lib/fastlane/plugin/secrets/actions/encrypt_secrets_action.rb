require 'fastlane/action'
require 'mobile-secrets'
require 'yaml'

module Fastlane
  module Actions
    class EncryptSecretsAction < Action
      def self.run(params)
        hash_key = params[:hash_key]
        language = params[:language]
        secrets_dir_path = params[:secrets_dir_path]
        secrets_dict = params[:secrets]
        files = params[:files]
        includes_password = params[:should_include_password]
        config_yml = {"MobileSecrets" => {"hashKey"=>hash_key,"language"=>language, "shouldIncludePassword"=>includes_password, "secrets"=>secrets_dict, "files"=>files}}.to_yaml

        MobileSecrets::SecretsHandler.new.encrypt "#{secrets_dir_path}/secrets.gpg", config_yml, secrets_dir_path
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
          FastlaneCore::ConfigItem.new(key: :hash_key,
                                       description: "Key that will be used to hash the secrets using XOR technique and encrypt files with AES, if files are encrypted the password must have 32 characters as an AES standard",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :language,
                                       description: "Source code language, currently supported - [swift]",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :secrets_dir_path,
                                        description: "Path to a directory where .gpg was initialized",
                                        is_string: true),
          FastlaneCore::ConfigItem.new(key: :should_include_password,
                                       description: "Defines whether the password will be added to the output file or whether it will be provided externally",
                                       type: Boolean,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :secrets,
                                       description: "Key-value dictionary of secrets",
                                       type: Hash,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :files,
                                       description: "Array of files that will be encrypted",
                                       type: Array,
                                       optional: true)
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
