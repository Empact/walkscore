require 'spec_helper'
require './lib/walkscore'
require 'support/vcr'
require 'support/dotenv'

RSpec.describe Walkscore::Score do
  before do
    Walkscore.api_key = api_key
  end

  describe '.find' do
    let(:api_key) { 'FAKE_API_KEY' }

    before(:each) do
      allow(Walkscore.http_client).to receive(:get).and_return(double(status: 200, body: <<-eos))
        {\n\"status\": 1  \n,
         \"walkscore\": 100\n,
         \"description\": \"Walker's Paradise\"\n,
         \"updated\": \"2012-06-27 23:22:43.598005\" \n,
         \"logo_url\": \"http://www2.walkscore.com/images/api-logo.gif\"\n,
         \"more_info_icon\": \"http://www2.walkscore.com/images/api-more-info.gif\"\n,
         \"more_info_link\": \"http://www.walkscore.com/how-it-works.shtml\"\n, \"ws_link\": \"http://www.walkscore.com/score/loc/lat=40.7143528/lng=-74.00597309999999/?utm_source=dynamiteurbanite.com&utm_medium=ws_api&utm_campaign=ws_api\"\n,
         \"snapped_lat\": 40.7145\n,
         \"snapped_lon\": -74.0055  \n\n\n\n}
      eos
    end

    it 'returns an instance of Walkscore::Score' do
      expect(described_class.find(lat: 40.7143528, long: -74.00597309999999)).
        to be_a(Walkscore::Score)
    end
  end

  describe '.find_json', :vcr do
    let(:api_key) { ENV['WALKSCORE_API_KEY'] }

    context 'when making a get request to the walkscore api' do
      it 'returns a status of 1 for successful connection' do
        result = VCR.use_cassette 'successful_connection' do
          described_class.find_json(lat: 40.7143528 , long: -74.00597309999999)
        end
        expect(result['status']).to eq(1)
        Walkscore::Score::STANDARD.each do |key, value|
          expect(result[key]).to eq(value)
        end
      end

      context 'when the api key is bad' do
        let(:api_key) { 'some_random_text' }

        it 'returns a status of 40 for unsuccessful connection' do
          expect {
            VCR.use_cassette 'unsuccessful_connection' do
              described_class.find_json(lat: 40.7143528 , long: -74.00597309999999)
            end
          }.to raise_error(Walkscore::InvalidApiKey)
        end
      end

      it 'returns a status of 30 for invalid location connection' do
        expect {
          VCR.use_cassette 'invalid_location_connection' do
            described_class.find_json(lat: -0.7143528 , long: 345.0059)
          end
        }.to raise_error(Walkscore::InvalidLatLong)
      end
    end
  end
end
