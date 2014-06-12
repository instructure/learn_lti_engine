require_dependency "learn_lti_engine/application_controller"

require "ims/lti"

module LearnLtiEngine
  class LtiController < ApplicationController
    def index
      @launch_params = params.reject!{ |k,v| ['controller','action'].include? k }
    end

    def launch
      @launch_params = params.reject!{ |k,v| ['controller','action'].include? k }
      # debugging on localhost
      if params[:mock_post_params].present?
        @launch_params = mock_post_params(params[:mock_post_params])
      end

      if @launch_params[:lis_result_sourcedid].present?
        @assignment = LearnLtiEngine::Assignment::ASSIGNMENTS[params[:assignment_name]]
        user = User.where(lti_user_id: @launch_params[:user_id]).first_or_create
        user.assignments.where(lti_assignment_id: @launch_params[:lis_result_sourcedid]).first_or_create!(type: "LearnLtiEngine::Assignments::#{params[:assignment_name].classify}")
        render layout: 'learn_lti_engine/ember'
      else
        render 'not_student'
      end
    end

    def embed
      launch_params = JSON.parse(params[:launch_params] || "{}")

      tp = IMS::LTI::ToolProvider.new(nil, nil, launch_params)
      tp.extend IMS::LTI::Extensions::Content::ToolProvider

      @content_type = "url"

      assignment = LearnLtiEngine::Assignment::ASSIGNMENTS[params[:assignment_name]]
      @title  = assignment["title"]
      @url    = launch_url(params[:assignment_name])

      redirect_url = tp.lti_launch_content_return_url(@url, @title, @title)

      if redirect_url.present?
        redirect_to redirect_url
      end
    end

    def xml_config
      host = "#{request.protocol}#{request.host_with_port}"
      url = "#{host}#{root_path}"
      title = "Learn Lti Engine"
      tool_id = "learn_lti_engine"
      tc = IMS::LTI::ToolConfig.new(:title => title, :launch_url => url)
      tc.extend IMS::LTI::Extensions::Canvas::ToolConfig
      tc.description = "[description goes here]"
      tc.canvas_privacy_anonymous!
      tc.canvas_domain!(request.host)
      tc.canvas_icon_url!("#{host}/assets/learn_lti_engine/icon.png")
      tc.canvas_text!(title)
      tc.set_ext_param('canvas.instructure.com', :tool_id, tool_id)
      tc.canvas_resource_selection!(enabled: true)
      render xml: tc.to_xml
    end

    def health_check
      head 200
    end

    private

    def mock_post_params(assignment_id)
      {
        oauth_consumer_key: "asdf",
        oauth_signature_method: "HMAC-SHA1",
        oauth_timestamp: "1401482037",
        oauth_nonce: "uXUn7YnMbH7gxH8DfCmtvmwZDf78gralGVim7gopo",
        oauth_version: "1.0",
        context_id: "6dea912122e999239a4663d99fc96ee4507a10bd",
        context_label: "LTI",
        context_title: "LTI Testing",
        custom_canvas_assignment_points_possible: "0",
        custom_canvas_assignment_title: "Learn LTI 1",
        custom_canvas_enrollment_state: "active",
        ext_ims_lis_basic_outcome_url: "https://karl.instructure.com/api/lti/v1/tools/307/ext_grade_passback",
        ext_outcome_data_values_accepted: "url,text",
        launch_presentation_document_target: "iframe",
        launch_presentation_locale: "en",
        launch_presentation_return_url: "https://karl.instructure.com/courses/1/external_tools/307/finished",
        lis_outcome_service_url: "https://karl.instructure.com/api/lti/v1/tools/307/grade_passback",
        lis_result_sourcedid: "307-1-96-1-012db6ed32f43301cf43611a919cd0b39957ce7d#{assignment_id}",
        lti_message_type: "basic-lti-launch-request",
        lti_version: "LTI-1p0",
        oauth_callback: "about:blank",
        resource_link_id: "90dbae24fe0d08e716fa47b1f120e6cee516222e",
        resource_link_title: "Learn LTI 1",
        roles: "Learner",
        tool_consumer_info_product_family_code: "canvas",
        tool_consumer_info_version: "cloud",
        tool_consumer_instance_contact_email: "notifications@instructure.com",
        tool_consumer_instance_guid: "7db438071375c02373713c12c73869ff2f470b68.karl.instructure.com",
        tool_consumer_instance_name: "Karl Lloyd Sandbox",
        user_id: "0340cde37624c04979a6c3fdd0afc2479f8405ad",
        user_image: "https://secure.gravatar.com/avatar/000?s=50&d=https%3A%2F%2Fcanvas.instructure.com%2Fimages%2Fmessages%2Favatar-50.png",
        oauth_signature: "tW11GB48xV/NzenbU2G92w406fc="
      }
    end
  end
end
