
class AuthController < ApplicationController

  def login
  end

  def auth
    admin_user = params[:adm_user].presence
    admin_pw   = params[:adm_pw].presence    || rand(1000000).to_s
    seeded_pw  = NewAccountOfferings::AdminPassword.presence || "00"
    seed,md5   = seeded_pw.split(/,/)
    enpw       = Digest::MD5.hexdigest("#{seed}#{admin_pw}")

    ok_admins = NewAccountOfferings::AdminUsernames

    if ok_admins.include?(admin_user) && enpw == md5
      session[:admin] = admin_user
      redirect_to :controller => :demands, :action => :index
    else
      sleep 3
      redirect_to :action => :login
    end
  end

  def deauth
    session[:admin] = nil
    redirect_to :action => :login
  end

end

