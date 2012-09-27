require 'spec_helper'

describe SiteController do

  context 'the index action' do

    it 'should have the correct response' do
      get :index
      response.should be_successful
      response.content_type.should be_json
    end

    it 'should include endpoints' do
      get :index
      decoded_response.endpoints.should be_present
    end

  end

end
