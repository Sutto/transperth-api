require 'spec_helper'

describe SiteController do

  context 'the index action' do

    it 'should have the correct response' do
      get :index
      expect(response).to be_successful
      expect(response.content_type).to be_json
    end

    it 'should include endpoints' do
      get :index
      expect(decoded_response.endpoints).to be_present
    end

  end

end
