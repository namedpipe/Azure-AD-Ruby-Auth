class OauthController < ApplicationController
	LOGIN_SITE = "https://login.windows.net"
	# Localhost d86fa567-622d-4ec4-a33b-40c8efabce4c
	# Other 557bfea1-b9c4-4dc8-abba-ea6487b03794
	# Localhost 8080 f87d4110-4498-4811-bb17=17b19e6666b0
	CLIENT_ID = "f87d4110-4498-4811-bb17-17b19e6666b0"
	#TOKEN_URL = "/c74b27a6-3ccd-4910-8d48-ef28f5980aad/oauth2/token"
	#AUTH_URL = "/c74b27a6-3ccd-4910-8d48-ef28f5980aad/oauth2/authorize"
	TOKEN_URL = "/common/oauth2/token"
	AUTH_URL = "/common/oauth2/authorize"
	#AUTH_URL = "/common/oauth2/authorize"
	# KEYS
	# api.haikutest.com key mnw7AfQCR9fKJXf0tuPlgUEqHNIWj15yDZOOfeJ942s=
	# localhost:3000 key B6k1vSrXkU9C8CRsSVYL3E2GdRlk0Z7gZlaL/mSY1xo=
	# localhost:8080 key testing
	#KEY = "B6k1vSrXkU9C8CRsSVYL3E2GdRlk0Z7gZlaL="
	KEY = "testing"
	APP_URL = "http://localhost:8080"

	def index
	end

	def login
		client = OAuth2::Client.new(CLIENT_ID, KEY,  
  		:site => LOGIN_SITE, 
  		:authorize_url => AUTH_URL,
  		:token_url => TOKEN_URL)

		login_url = client.auth_code.authorize_url(:redirect_uri => "#{APP_URL}/consume", :resource => "https://graph.windows.net")
		redirect_to login_url

		# Used for testing SAML login
		#request = Onelogin::Saml::Authrequest.new
		#redirect_to(request.create(saml_settings))
	end

	def consume
		client = OAuth2::Client.new(CLIENT_ID, KEY,  
  		:site => LOGIN_SITE, 
  		:authorize_url => AUTH_URL,
  		:token_url => TOKEN_URL)
		if params[:code]
			@token = client.auth_code.get_token(params[:code], :redirect_uri => "#{APP_URL}/consume")
			@response = @token.get('https://graph.windows.net/me?api-version=2013-04-05')
		end

		# Used for testing SAML login
		#response          = Onelogin::Saml::Response.new(params[:SAMLResponse])
		#response.settings = saml_settings
		#if response.is_valid?
    #end
	end

	def finalize
	end

	private
	def saml_settings
    settings = Onelogin::Saml::Settings.new

    settings.assertion_consumer_service_url = "http://#{request.host}:3000/consume"
    settings.issuer                         = request.host
    settings.idp_sso_target_url             = "https://login.windows.net/c74b27a6-3ccd-4910-8d48-ef28f5980aad/saml2"
    settings.idp_cert_fingerprint           = "34 64 C5 BD D2 BE 7F 2B 61 12 E2 F0 8E 9C 00 24 E3 3D 9F E0"
    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    # Optional for most SAML IdPs
    settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

    settings
  end

end