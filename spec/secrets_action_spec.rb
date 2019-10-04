describe Fastlane::Actions::EncryptSecretsAction do
  describe '#run' do
    it 'does something' do
      #expect(Fastlane::UI).to receive(:message).with("The secrets plugin is working!")
      args = {
        :hash_key => "simsalabim",
        :language => "swift",
        :target_path => "output",
        :secrets => {
          "SECRET_KEY" => "kL7o0y4QMI",
          "API_TOKEN" => "51NLb1ntbw9DCFPseOSu3Zlvp2EpCTVt"
        }
      }
      keys = Fastlane::Actions::EncryptSecretsAction.available_options.map {|item| item.key }
      keys.sort.equal? args.keys.sort
    end
  end
end
