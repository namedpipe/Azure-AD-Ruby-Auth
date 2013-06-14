class OauthController < ApplicationController
	LOGIN_SITE = "https://login.windows.net"
	CLIENT_ID = "557bfea1-b9c4-4dc8-abba-ea6487b03794"
	TOKEN_URL = "/c74b27a6-3ccd-4910-8d48-ef28f5980aad/oauth2/token"
	AUTH_URL = "/c74b27a6-3ccd-4910-8d48-ef28f5980aad/oauth2/authorize"
	# KEYS
	# api.haikutest.com key mnw7AfQCR9fKJXf0tuPlgUEqHNIWj15yDZOOfeJ942s=
	# localhost:3000 key B6k1vSrXkU9C8CRsSVYL3E2GdRlk0Z7gZlaL/mSY1xo=
	KEY = "mnw7AfQCR9fKJXf0tuPlgUEqHNIWj15yDZOOfeJ942s="

	def index
	end

	def login
		client = OAuth2::Client.new(CLIENT_ID, KEY,  
  		:site => LOGIN_SITE, 
  		:authorize_url => AUTH_URL,
  		:token_url => TOKEN_URL)

		login_url = client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/consume', :resource => "http://localhost:3000")
		redirect_to login_url

		# Used for testing SAML login
		#request = Onelogin::Saml::Authrequest.new
		#redirect_to(request.create(saml_settings))
	end

	def consume
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