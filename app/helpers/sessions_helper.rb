module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user?(user)
		@current_user == user
	end

	def current_user
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def signed_in?
		signed_in = !current_user.nil?
	end

	def sign_out
		current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def redirect_back_or(default)
		if session[:return_to].blank?
	    	redirect_to default
	    else
	    	redirect_to session[:return_to]
	    	session.delete(:return_to)
	    end
  	end

    def store_location
    	if request.get?
  	    	session[:return_to] = request.url
  	    end
  	end
end

