
class ApprovalResult
   attr_accessor :diagnostics, :plain_password

   def to_s
     self.diagnostics.presence.to_s
   end

end

class Demand < ActiveRecord::Base

#    t.string   "title"
#    t.string   "first"
#    t.string   "middle"
#    t.string   "last"
#    t.string   "institution"
#    t.string   "department"
#    t.string   "position"
#    t.string   "email"
#    t.string   "street1"
#    t.string   "street2"
#    t.string   "city"
#    t.string   "province"
#    t.string   "country"
#    t.string   "postal_code"
#    t.string   "time_zone"
#    t.string   "service"
#    t.string   "login"
#    t.string   "comment"
#
#    t.string   "session_id"
#    t.string   "confirm_token"
#    t.boolean  "confirmed"
#
#    t.string   "approved_by"
#    t.datetime "approved_at"
#    t.datetime "created_at"
#    t.datetime "updated_at"

  validate              :strip_blanks

  attr_accessible       :title, :first, :middle, :last,
                        :institution, :department, :position, :email,
                        :street1, :street2, :city, :province, :country, :postal_code,
                        :service, :login, :time_zone, :comment

  validates_presence_of :first, :last,
                        :institution, :department, :position, :email,
                        :province, :country,
                        :service, :confirm_token

  validates             :login, :length => { :minimum => 3, :maximum => 8 }, :allow_blank => true
  validates             :login, :format => { :with => /^[a-zA-Z]\w+$/ }

  validates             :email, :format => { :with => /^(\w[\w\-\.]*)@(\w[\w\-]*\.)+[a-z]{2,}$|^\w+@localhost$/i }

  #validates_length_of   :postal_code, :within => 5..10

  def strip_blanks
    [
      :title, :first, :middle, :last,
      :institution, :department, :position, :email,
      :street1, :street2, :city, :province, :country, :postal_code,
      :service, :login, :comment
    ].each do |att|
      val = read_attribute(att) || ""
      write_attribute(att, val.strip)
    end
    self.login = (self.login.presence || "").downcase
    true
  end

  def generate_token
    tok = ""
    20.times { c=sprintf("%d",rand(10)); tok += c }
    self.confirm_token = tok
  end

  def full
    "#{title} #{first} #{middle} #{last}".strip.gsub(/  +/, " ")
  end

  alias full_name full

  def self.uniq_login_cnts
    login_cnts = {}
    Demand.select(:login).all.each { |d| e=d.login.downcase;login_cnts[e] ||= 0;login_cnts[e] += 1 }
    login_cnts
  end

  def self.uniq_email_cnts
    email_cnts = {}
    Demand.select(:email).all.each { |d| e=d.email.downcase;email_cnts[e] ||= 0;email_cnts[e] += 1 }
    email_cnts
  end

  def after_approval
    puts "Approving: #{self.full}"
    chars = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).shuffle.reject { |c| c =~ /[01OolI]/ }
    salt  = chars[0] + chars[1]
    password = ""
    12.times { password += chars[rand(chars.size)] }

    # LORIS convention:
    # UPDATE users SET Password_md5=concat('aa',MD5('aatest'));

    salted_md5 = Digest::MD5.hexdigest( salt + password )

    mylogin = self.login.presence || (self.first[0,1] + self.last).downcase
    self.login = mylogin
    unless self.valid?
       Raise "Current record is invalid. Probably: login name incorrect. Check form values."
    end

    guest_psc  = LorisPsc.find_by_Alias('GST') # must have been created manually by the admin
    loris_user = LorisUser.new

    att_map = { # values will be escaped later on
      'UserID'          => :login,
      'Real_name'       => self.full_name,
      'First_name'      => :first,
      'Last_name'       => :last,
      'Position_title'  => :position,
      'Institution'     => :institution,
      'Department'      => :department,
      'Address'         => "#{self.street1} #{self.street2}",
      'City'            => :city,
      'State'           => :province,
      'Zip_code'        => :postal_code,
      'Country'         => :country,
      'Email'           => :email,
      'Password_md5'    => salt + salted_md5,
      'Password_expiry' => Time.zone.now.strftime("%Y-%m-%d"),
      'CenterID'        => guest_psc.CenterID
    }

    att_map.each do |col,val|
      val = self.send(val) if val.is_a?(Symbol) # symbols are fetched as attributes of demand object
      accessor = col.to_sym
      begin
        loris_user.send("#{accessor}=", val)
      rescue
        Rails.logger.error "Bad att pair: #{accessor} = #{val}"
        raise
      end
    end

    loris_user.save!

    res = ApprovalResult.new;
    res.plain_password = password
    res.diagnostics    = ""

    return res
  end

end

