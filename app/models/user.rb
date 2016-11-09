require 'digest'
require 'securerandom'

class User < ApplicationRecord
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_one  :user_profile
  has_many :sites

  # These are the sites that this user has a GUEST relationship...
  def guest_sites
    Site.where(user_id: Guest.where(guest_id: self.id).select(:owner_id))
  end

  def set_default_role
    self.role ||= :user
    self.id = (User.maximum("id")).to_i + 1
    self.build_profile
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable # Backwards compatible passwords

  ## For PHP password compatibility
  def password_salt
    self.legacy_password_salt || "MakeThisBCryptASAP"
  end

  def password_salt=(new_salt)
  end

  ##generate api keys
  #$profile->setCustomerKey(hash('ripemd160', $this->secureRandom->nextBytes(64)));
  #$profile->setCustomerSecret(hash('sha256', $this->secureRandom->nextBytes(64)));
  def build_profile
    @user_profile = UserProfile.new

    if !@user_profile.user_id
      @user_profile.user_id = (User.maximum("id")).to_i + 1
      @user_profile.customer_key = Digest::RMD160.hexdigest (SecureRandom.base64(24))
      @user_profile.customer_secret = Digest::SHA256.hexdigest (SecureRandom.base64(24))
      #default service plan FREE
      @user_profile.service_plan_id = 47
      self.user_profile = @user_profile
      self.save
    end

  end

end
