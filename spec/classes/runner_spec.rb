require 'spec_helper'

describe 'sonarqube::runner' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'when installing' do
        it { should create_class('sonarqube::runner::install') }
        it { should create_class('sonarqube::runner::config') }
      end
    end
  end
end
