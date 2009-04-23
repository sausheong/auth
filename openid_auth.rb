%w(rubygems sinatra openid openid/store/filesystem).each  { |lib| require lib}

REALM = 'http://localhost:4567'
RETURN_TO = "#{REALM}/complete"

get '/login' do
  identifier = params[:openid_identifier]
  checkid_request = openid_consumer.begin(identifier)
  redirect checkid_request.redirect_url(REALM, RETURN_TO) if checkid_request.send_redirect?(REALM, RETURN_TO)
  checkid_request.html_markup(REALM, RETURN_TO)
end

get '/complete' do
  response = openid_consumer.complete(params, RETURN_TO)
  return response.identity_url.inspect if response.status == OpenID::Consumer::SUCCESS
  'Could not log on with your OpenID'
end

def openid_consumer
  if @consumer.nil?
    store = OpenID::Store::Filesystem.new('auth/store')
    @consumer = OpenID::Consumer.new(session, store)
  end
  return @consumer
end