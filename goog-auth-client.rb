Shoes.setup do
   gem 'rest-client'
   gem 'net-ssh'
   
end
%w(rest_client openssl.so openssl/bn openssl/cipher openssl/digest openssl/ssl openssl/x509 net/ssh).each  { |lib| require lib}

class GoogleAuthClient < Shoes
  url '/', :login
  url '/list', :list
  
  def login
    stack do
      title "Please login", :margin => 4    
      para "Log in using your Google credentials!"  
      flow :margin_left => 4 do para "Email"; @me = edit_line; end 
      flow :margin_left => 4 do para "Password"; @password = edit_line :secret => true; end
      button "login" do $me = @me.text; authenticate(@me.text,@password.text) ? visit('/list') : alert("Wrong email or password"); end  
    end
  end
  
  def list
    title "You are logged in!"
  end
  
  def authenticate(email,password)
    response = RestClient.post 'https://www.google.com/accounts/ClientLogin', 'accountType' => 'HOSTED_OR_GOOGLE', 'Email' => email, 'Passwd' => password, :service => 'xapi', :source => 'Goog-Auth-1.0'
    return true if response.code == 200
    return false
  end   
end
Shoes.app :width => 400, :height => 200, :title => 'Google Authenticator'
