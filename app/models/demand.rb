
#class User < ActiveRecord::Base
#end

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

  def after_approval
    puts "Approving: #{self.full}"
#    salt       = rand(10000000).to_s
#    password   = rand(10000000).to_s + rand(10000000).to_s + rand(10000000).to_s
#    pw = Digest::SHA1.hexdigest("--#{salt}--#{password}--")
#
#    login = (self.first[0,1] + self.last).downcase
#    found = User.find_by_login(login)
#
#    if found
#      ex = RuntimeError.new("User '#{login}' already exists.")
#      ex.set_backtrace([])
#      raise ex
#    end
#
#    user = User.create(
#      :login              => login,
#      :full_name          => self.full,
#      :email              => self.email,
#      :role               => 'user',
#      :password_reset     => false,
#      :time_zone          => self.time_zone.presence,
#      :city               => self.city,
#      :country            => self.country,
#      :account_locked     => true,
#      :crypted_password   => pw
#   )
# 
#   "Created User # #{user.id}."
    "TODO HERE: Create user '#{self.full}' for service '#{self.service}'."
  end

end

