NewAccount::Application.routes.draw do

  root :to       => 'demands#new'
  match '/'      => 'demands#new' 
  match '/home'  => 'demands#new' 

  resources :demands do
    member do
      post 'approve'
      post 'resend_confirm'
      get  'confirm'
    end
  end

  match 'auth/login',   :controller => :auth, :action => :login,  :via => :get
  match 'auth/auth',    :controller => :auth, :action => :auth,   :via => :post
  match 'auth/deauth',  :controller => :auth, :action => :deauth, :via => :get

end
