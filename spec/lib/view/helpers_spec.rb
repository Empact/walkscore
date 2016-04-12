require 'spec_helper'
require './lib/walkscore/view/helpers'

RSpec.describe Walkscore::View::Helpers do
  include Walkscore::View::Helpers

  describe '#walkscore_text_tag' do
    context 'with a hash' do
      context 'when Walkscore.premium is enabled' do
        before { Walkscore.premium = true }

        context 'without a walkscore' do
          it 'raises' do
            expect { walkscore_text_tag({}) }.to raise_error(KeyError)
          end
        end

        context 'with a walkscore' do
          it 'returns the tag' do
            expect(walkscore_text_tag('walkscore' => '50')).to eq(
              %{<a href="https://www.redfin.com/how-walk-score-works">Walk Score®</a>: <a href="https://www.redfin.com/how-walk-score-works">50</a>}
            )
          end

          context 'and a ws_link' do
            it 'returns the tag with the ws_link url' do
              expect(walkscore_text_tag('walkscore' => '50', 'ws_link' => 'https://example.com')).to eq(
                %{<a href="https://example.com">Walk Score®</a>: <a href="https://example.com">50</a>}
              )
            end
          end
        end
      end

      context 'without a walkscore' do
        it 'raises' do
          expect { walkscore_text_tag({}) }.to raise_error(KeyError)
        end
      end

      context 'with a walkscore' do
        it 'returns the tag' do
          expect(walkscore_text_tag('walkscore' => '50')).to eq(
            %{<a href="https://www.redfin.com/how-walk-score-works">Walk Score®</a>: <a href="https://www.redfin.com/how-walk-score-works">50</a>}
          )
        end
      end
    end
  end

  describe '#walkscore_logo_tag' do
    context 'when Walkscore.premium is enabled' do
      before { Walkscore.premium = true }

      context 'without a walkscore' do
        it 'raises' do
          expect { walkscore_logo_tag({}) }.to raise_error(KeyError)
        end
      end

      context 'with a walkscore' do
        it 'returns the tag' do
          expect(walkscore_logo_tag('walkscore' => '50')).to eq(
            %{<a href="https://www.redfin.com/how-walk-score-works"><img src="https://cdn.walk.sc/images/api-logo.png" alt="Walk Score®"></a>: <a href="https://www.redfin.com/how-walk-score-works">50</a>}
          )
        end

        context 'and a ws_link' do
          it 'returns the tag with the ws_link url' do
            expect(walkscore_logo_tag('walkscore' => '50', 'ws_link' => 'https://example.com')).to eq(
              %{<a href="https://example.com"><img src="https://cdn.walk.sc/images/api-logo.png" alt="Walk Score®"></a>: <a href="https://example.com">50</a>}
            )
          end
        end
      end
    end

    context 'without a walkscore' do
      it 'raises' do
        expect { walkscore_logo_tag({}) }.to raise_error(KeyError)
      end
    end

    context 'with a walkscore' do
      it 'returns the tag' do
        expect(walkscore_logo_tag('walkscore' => '50')).to eq(
          %{<a href="https://www.redfin.com/how-walk-score-works"><img src="https://cdn.walk.sc/images/api-logo.png" alt="Walk Score®"></a>: <a href="https://www.redfin.com/how-walk-score-works">50</a>}
        )
      end
    end
  end
end
