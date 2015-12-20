require 'spec_helper'
describe 'fujitsusvagents' do

  context 'with defaults for all parameters' do
    it { should contain_class('fujitsusvagents') }
  end
end
