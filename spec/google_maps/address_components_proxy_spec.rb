# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Google::Maps::AddressComponentsProxy do
  let(:address_components) do
    [
      OpenStruct.new(
        long_name: 'Pyrmont',
        short_name: 'Py',
        types: %w[locality political]
      ),
      OpenStruct.new(
        long_name: 'Australia',
        short_name: 'AU',
        types: %w[country political]
      ),
      OpenStruct.new(
        long_name: '1009',
        short_name: '1009',
        types: %w[postal_code]
      )
    ]
  end

  describe '#access of type values' do
    subject { Google::Maps::AddressComponentsProxy.new(address_components) }

    describe '#postal_code' do
      it { expect(subject.postal_code).to be_present }

      describe '#short_name' do
        it { expect(subject.postal_code.long_name).to eq('1009') }
      end

      describe '#long_name' do
        it { expect(subject.postal_code.short_name).to eq('1009') }
      end
    end

    describe '#locality' do
      it { expect(subject.locality).to be_present }

      describe '#short_name' do
        it { expect(subject.locality.short_name).to eq('Py') }
      end

      describe '#long_name' do
        it { expect(subject.locality.long_name).to eq('Pyrmont') }
      end
    end

    describe '#country' do
      it { expect(subject.country).to be_present }

      describe '#short_name' do
        it { expect(subject.country.short_name).to eq('AU') }
      end

      describe '#long_name' do
        it { expect(subject.country.long_name).to eq('Australia') }
      end
    end
  end
end
