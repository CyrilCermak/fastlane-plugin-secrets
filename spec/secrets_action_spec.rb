describe Fastlane::Actions::SecretsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The secrets plugin is working!")

      Fastlane::Actions::SecretsAction.run(nil)
    end
  end
end
