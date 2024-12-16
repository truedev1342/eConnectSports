class ApplicationController < ActionController::Base
	protect_from_forgery

	before_filter :force_www!
	# before_filter :set_cache_buster

	def default_url_options
		if Rails.env.production?
			{:host => "www.idigitallsports.com"}
		else  
			{}
		end
	end

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_path, :alert => exception.message
	end

	def record_activity(note)
	    @activity = Activity.new
	    @activity.user = current_user
	    @activity.note = note
	    @activity.browser = request.env['HTTP_USER_AGENT']
	    @activity.ip_address = request.env['REMOTE_ADDR']
	    @activity.controller = controller_name 
	    @activity.action = action_name 
	    @activity.params = params.inspect
	    @activity.save
	end

	def current_url
		request.protocol+request.host.to_s+request.fullpath.to_s
	end
	helper_method :current_url

	def current_host
		if Rails.env.production?
			request.host
		else
			request.host_with_port
		end
	end
	helper_method :current_host

    def mobile_device?
      	request.user_agent =~ /Mobile|webOS/
    end
    helper_method :mobile_device?

    def ios_device?
    	request.user_agent =~ /(Mobile\/.+Safari)/
    end
    helper_method :ios_device?

    def old_ie?
    	request.user_agent =~ /MSIE 8.0|MSIE 7.0/
    end
    helper_method :old_ie?

    protected

    def force_www!
	  if Rails.env.production? and request.host[0..18] == "idigitallsports.com"
	    redirect_to "#{request.protocol}www.#{request.host_with_port}#{request.fullpath}", :status => 301
	  end
	end

	def set_cache_buster
		response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		response.headers["Pragma"] = "no-cache"
		response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
	end
end
