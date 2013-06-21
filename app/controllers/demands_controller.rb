
class DemandsController < ApplicationController

  def show
    @demand = Demand.find(params[:id]) rescue nil
    unless can_edit?(@demand)
      redirect_to :action => :new
      return
    end
  end

  def new
    @demand = Demand.new
  end

  def create
    @demand = Demand.new(params[:demand])
    @demand.session_id = session[:session_id]
    @demand.generate_token

    unless can_edit?(@demand)
      redirect_to :action => :new
      return
    end

    if ! @demand.save
      render :action => :new
      return
    end

    send_confirm_email(@demand)
    send_admin_notification(@demand)

    sleep 1
    redirect_to :action => :show, :id => @demand.id
  end

  def edit
    @demand = Demand.find(params[:id]) rescue nil
    unless can_edit?(@demand)
      redirect_to :action => :new
      return
    end
    render :action => :new
  end

  def update
    @demand = Demand.find(params[:id]) rescue nil

    unless can_edit?(@demand)
      redirect_to :action => :new
      return
    end

    @demand.update_attributes(params[:demand])

    if ! @demand.save
      render :action => :new
      return
    end

    flash[:notice] = "The account request has been updated."

    sleep 1
    redirect_to :action => :show, :id => @demand.id
  end

  def index
    if session[:admin].blank?
      redirect_to :action => :new
    end
    @page_size = 50
    @page      = (params[:page].presence || session[:page].presence || "1").to_i
    @tot       = Demand.count

    session[:page] = @page.to_s

    @demands = Demand.where(params[:filt] || {}).offset((@page-1) * @page_size).limit(@page_size).all
  end

  def destroy
    @demand = Demand.find(params[:id]) rescue nil

    unless can_edit?(@demand)
      redirect_to :action => :new
      return
    end

    @demand.destroy
    flash[:notice] = "The account request has been deleted."

    if session[:admin].present?
      redirect_to :action => :index
    else
      redirect_to :action => :new
    end
  end

  def confirm
    @demand = Demand.find(params[:id]) rescue nil
    token    = params[:token] || ""
    if @demand.present? && token.present? && @demand.confirm_token == token
      @demand.confirmed = true
      @demand.save
    else
      redirect_to :root
    end
  end

  def approve
    @demand = Demand.find(params[:id]) rescue nil
    unless can_edit?(@demand) && session[:admin].present?
      redirect_to :action => :new
      return
    end

    if @demand.login.blank?
      flash[:error] = "Before approval, a 'login' name must be set."
      redirect_to :action => :edit, :id => @demand.id
      return
    end

    result = nil
    @exception_trace = ""

    if @demand.respond_to?(:after_approval)
      begin
        result = @demand.after_approval
        flash.now[:notice] = "The after_approval callback was successfully invoked."
      rescue => ex
        flash.now[:error] = "An exception was raised in the after_approval callback.";
        @exception_trace = "#{ex.class}: #{ex.message}\n" +
                           ex.backtrace.join("\n")
      end
    end

    @info          = result.diagnostics    rescue nil
    plain_password = result.plain_password rescue nil

    if @exception_trace.blank?
      @demand.approved_by ||= session[:admin]
      @demand.approved_at ||= Time.now
      @demand.save
      flash.now[:notice] += "\nThe account request for '#{@demand.full}' has been approved."
      send_account_created_email(@demand,plain_password) && flash.now[:notice] += "\nThe user was notified of his new account."
    end

  end

  def resend_confirm
    @demand = Demand.find(params[:id]) rescue nil
    unless can_edit?(@demand)
      redirect_to :action => :new
      return
    end

    send_confirm_email(@demand) && flash[:notice] = "A new confirmation email has been sent."

    sleep 1
    redirect_to :action => :show, :id => @demand.id
  end

  private

  def can_edit?(demand)
    return false if demand.blank?
    return true  if session[:admin].present?
    return true  if demand[:session_id] == session[:session_id]
    false
  end

  def send_confirm_email(demand)
    confirm_url = url_for(:controller => :demands, :action => :confirm, :id => demand.id, :only_path => false, :token => demand.confirm_token)
    ConfirmMailer.request_confirmation(demand, confirm_url).deliver
    return true
  rescue => ex
    Rails.logger.error ex.to_s
    flash[:error] = "It seems some error occured. Email notification was probably not sent. Sorry. We'll look into that."
    return false
  end

  def send_account_created_email(demand, plain_password = nil)
    ConfirmMailer.account_created(demand, plain_password).deliver
    return true
  rescue => ex
    Rails.logger.error ex.to_s
    flash.now[:error] ||= ""
    flash.now[:error]  += "It seems some error occured. The email telling the user the account was created was probably not sent."
    return false
  end

  def send_admin_notification(demand)
    return if NewAccountOfferings::AdminNotificationEmail.blank?
    login_url = url_for(:controller => :auth,    :action => :login,                  :only_path => false)
    show_url  = url_for(:controller => :demands, :action => :show, :id => demand.id, :only_path => false)
    ConfirmMailer.notify_admin(demand, login_url, show_url).deliver
    return true
  rescue => ex
    Rails.logger.error ex.to_s
    flash[:error] = "It seems some error occured. Email notification was probably not sent. Sorry. We'll look into that."
    return false
  end

end

