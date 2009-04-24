%w(rubygems sinatra rest_client json).each  { |lib| require lib}

get '/login' do
  'You are logged in!' if authenticate(params[:token])  
end

def authenticate(token)
  response = JSON.parse(RestClient.post 'https://rpxnow.com/api/v2/auth_info', :token => token, 'apiKey' => '<INSERT API KEY HERE>', :format => 'json')
  return true if response['stat'] == 'ok'
  return false
end