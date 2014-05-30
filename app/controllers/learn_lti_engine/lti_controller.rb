require_dependency "learn_lti_engine/application_controller"

require "ims/lti"

module LearnLtiEngine
  class LtiController < ApplicationController
    def index
      @launch_params = params.reject!{ |k,v| ['controller','action'].include? k }
    end

    def launch
      url = params[:url]
      if url && url =~ /\Ahttps?:\/\/.+\..+\Z/
        redirect_to url
      else
        head 500
      end
    end

    def embed
      launch_params = JSON.parse(params[:launch_params] || "{}")

      tp = IMS::LTI::ToolProvider.new(nil, nil, launch_params)
      tp.extend IMS::LTI::Extensions::Content::ToolProvider

      # The following code is used as an example of content being returned.
      # This should be replaced by actual logic.
      embed_type = params[:embed_type]
      if embed_type =~ /Video/
        @content_type = "iframe"
        @title = "Getting Started in Canvas Network"
        @url = "https://player.vimeo.com/video/79702646"
        @width = "500"
        @height = "284"
      elsif embed_type =~ /Picture/
        @content_type = "image_url"
        @title = "Laughing Dog"
        @url = "https://dl.dropboxusercontent.com/u/2176587/laughing_dog.jpeg"
        @width = "284"
        @height = "177"
      elsif embed_type =~ /Link/
        @content_type = "url"
        @title  = "Edu App Center"
        @url    = "https://www.eduappcenter.com"
      end

      redirect_url = build_url(tp, @title, @url, @width, @height, @content_type)

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

    def build_url(tp, title, url, width, height, content_type)
      if tp.accepts_content?
        redirect_url = nil
        if content_type == "image_url" && tp.accepts_url?
          redirect_url = tp.image_content_return_url(url, width, height, title)
        elsif content_type == "iframe" && tp.accepts_iframe?
          redirect_url = tp.iframe_content_return_url(url, width, height, title)
        elsif tp.accepts_url?
          redirect_url = tp.url_content_return_url(url, title, title)
        elsif tp.accepts_lti_launch_url?
          launch_url = launch_url(url: url)
          redirect_url = tp.lti_launch_content_return_url(launch_url, title, title)
        end
        return redirect_url
      end
    end
  end
end
