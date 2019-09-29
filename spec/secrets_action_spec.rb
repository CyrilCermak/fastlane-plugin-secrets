describe Fastlane::Actions::SecretsAction do
  describe '#run' do
    it 'does something' do
      #expect(Fastlane::UI).to receive(:message).with("The secrets plugin is working!")

      args = {
        :key_value_list => {
          "SECRET_KEY" => "kL7o0y4QMI",
          "API_TOKEN" => "51NLb1ntbw9DCFPseOSu3Zlvp2EpCTVt"
        },
        :salt => "simsalabim",
        :target_path => "output/"
      }

      Fastlane::Actions::SecretsAction.run(args)
    end
  end
end
