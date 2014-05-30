require 'spec_helper'

module LearnLtiEngine
  describe TestController do

    describe "GET 'backdoor'" do
      it "returns http success" do
        get 'backdoor', use_route: :learn_lti_engine
        response.should be_success
      end
    end

  end
end
