require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class SecretsHelper

      def self.inject_secrets(secret_bytes, file)
        template = IO.read "#{__dir__}/SecretsTemplate.swift"
        secret_bytes = "#{secret_bytes}".gsub "],", "],\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"
        bytes_variable = "private let bytes: [[UInt8]] = #{secret_bytes}"
        swift_secrets = template.sub "/* SECRET BYTES */", bytes_variable

        File.open(file, "w") do |f|
          f.puts swift_secrets
        end
      end

      def self.xor_chiper(key, string)
        key_chars = key.chars
        result = ""
        codepoints = string.each_codepoint.to_a
        codepoints.each_index do |i|
          result += (codepoints[i] ^ key_chars[i % key_chars.size].ord).chr
        end
        result
      end

    end
  end
end
