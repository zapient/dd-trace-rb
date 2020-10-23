require 'ddtrace/contrib/support/spec_helper'
require 'ddtrace/contrib/cucumber/patcher'

RSpec.describe Datadog::Contrib::Cucumber::Patcher do
  describe '.patch' do
    subject!(:patch) { described_class.patch }

    let(:runtime) { Cucumber::Runtime.new }

    before do
      described_class.patch
    end

    context 'is patched' do
      let(:handlers) { runtime.configuration.event_bus.instance_variable_get(:'@handlers') }

      it do
        expect(handlers).to include(&runtime.datadog_events.method(:on_test_case_started))
        expect(handlers).to include(&runtime.datadog_events.method(:on_test_case_finished))
        expect(handlers).to include(&runtime.datadog_events.method(:on_test_step_started))
        expect(handlers).to include(&runtime.datadog_events.method(:on_test_step_finished))
      end
    end
  end
end
