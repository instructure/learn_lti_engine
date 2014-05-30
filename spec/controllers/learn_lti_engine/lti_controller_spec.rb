require 'spec_helper'

module LearnLtiEngine
  describe LtiController do

    describe "GET 'index'" do
      it "returns http success" do
        get 'index', use_route: :learn_lti_engine
        response.should be_success
      end
      describe "GET config" do
        it "should generate a valid xml cartridge" do
          request.stub(:env).and_return({
            "SCRIPT_NAME"     => "/learn_lti_engine",
            "rack.url_scheme" => "http",
            "HTTP_HOST"       => "test.host",
            "PATH_INFO"       => "/learn_lti_engine"
          })
          get 'xml_config', use_route: :learn_lti_engine
          expect(response.body).to include('<blti:title>Learn Lti Engine</blti:title>')
          expect(response.body).to include('<blti:description>[description goes here]</blti:description>')
          expect(response.body).to include('<lticm:property name="text">Learn Lti Engine</lticm:property>')
          expect(response.body).to include('<lticm:property name="tool_id">learn_lti_engine</lticm:property>')
          expect(response.body).to include('<lticm:property name="icon_url">http://test.host/assets/learn_lti_engine/icon.png</lticm:property>')


          expect(response.body).to include('<lticm:options name="resource_selection">')

        end
      end
    end

  end
end
