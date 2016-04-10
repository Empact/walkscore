require 'spec_helper'
require 'support/vcr'
require 'support/dotenv'

describe Walkscore::Client do
  describe '#find_json', :vcr do
    let(:api_key) { ENV['WALKSCORE_API_KEY'] }
    let(:client) { Walkscore::Client.new(api_key: api_key) }

    context 'when making a get request to the walkscore api' do
      it 'returns a status of 1 for successful connection' do
        result = VCR.use_cassette 'successful_connection' do
          client.find_json(lat: 40.7143528 , long: -74.00597309999999)
        end
        expect(result['status']).to eq(1)
      end

      context 'when the api key is bad' do
        let(:api_key) { 'some_random_text' }

        it 'returns a status of 40 for unsuccessful connection' do
          expect {
            VCR.use_cassette 'unsuccessful_connection' do
              client.find_json(lat: 40.7143528 , long: -74.00597309999999)
            end
          }.to raise_error(Walkscore::InvalidApiKey)
        end
      end

      it 'returns a status of 30 for invalid location connection' do
        expect {
          VCR.use_cassette 'invalid_location_connection' do
            client.find_json(lat: -0.7143528 , long: 345.0059)
          end
        }.to raise_error(Walkscore::InvalidLatLong)
      end
    end
  end
end
