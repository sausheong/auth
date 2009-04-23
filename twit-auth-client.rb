class TwitterAuthClient < Shoes
  url '/', :login
  url '/list', :list
  
  def login
    stack do
      title "Please login", :margin => 4    
      para "Log in using your Twitter credentials!"  
      flow :margin_left => 4 do para "Username"; @me = edit_line; end 
      flow :margin_left => 4 do para "Password"; @password = edit_line :secret => true; end
      button "login" do $me = @me.text; authenticate(@me.text,@password.text) ? visit('/list') : alert("Wrong user or password"); end  
    end
  end
  
  def list
    title "You are logged in!"
  end
  
  def authenticate(user,password)
    open("http://twitter.com/account/verify_credentials.xml", :http_basic_authentication=>[user, password]) rescue return false
    return true
  end   
end
Shoes.app :width => 400, :height => 200, :title => 'Twitter authenticator'
