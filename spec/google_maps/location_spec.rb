# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Google::Maps::Location do
  let(:address) { 'Science Park 400, Amsterdam' }

  describe '.find' do
    context 'when location is found' do
      before do
        stub_response('geocoder/science-park-400-amsterdam-nl.json')
        @response = Google::Maps::Location.find(address, :nl)
      end

      it { expect(@response).to be_a(Array) }

      describe 'attributes' do
        subject(:location) { @response.first }

        it 'should have address' do
          expect(location.address).to include(address)
        end

        it 'should have latitude and longitude' do
          expect(location.latitude).to eq(52.3564490)
          expect(location.longitude).to eq(4.95568890)
          expect(location.lat_lng).to eq([52.3564490, 4.95568890])
        end

        it 'should have address components' do
          expect(location.address_components).to be_present
        end

        context '#address_components' do
          it 'allows easy access by type' do
            expect(location.address_components.postal_code.long_name).to eq('1098 XH')
            expect(location.address_components.locality.long_name).to eq('Amsterdam')
          end
        end
      end
    end

    context 'when location is not found' do
      subject { Google::Maps::Location.find(address) }

      before do
        stub_response('zero-results.json')
      end

      it { expect { subject }.to raise_error(Google::Maps::ZeroResultsException) }
    end
  end
end
