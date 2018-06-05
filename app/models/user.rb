class User < ActiveRecord::Base

devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable #, :confirmable

   def after_database_authentication
        # here's the custom code
        # UserMailer.welcome_email(User.last).deliver_now
  end

    has_many :deputies, as: :owner, dependent: :destroy 
    has_many :charges, as: :owner, dependent: :destroy 
    has_many :mobjects, as: :owner, dependent: :destroy 
    has_many :credentials, dependent: :destroy 
    has_many :webmasters, dependent: :destroy 
    has_many :companies, dependent: :destroy 
    has_many :madvisors, dependent: :destroy
    has_many :favourits, dependent: :destroy 
    has_many :searches, dependent: :destroy
    has_many :games, dependent: :destroy

    # validates :userid, presence: true, :uniqueness => true
    validates :lastname, presence: true    
    validates :name, presence: true
    
    before_validation :update_geo_address
    geocoded_by :geo_address
    after_validation :geocode

    has_attached_file :avatar, default_url: "/images/:style/missing.png", :styles => {:medium => "250x250#", :small => "50x50#" }
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
    
    def self.search(filter, search)
        if filter
            @search = Search.find(filter)
            where(@search.build_sql(nil))
        else
            if search
                where('status=? and anonymous=? and active=? and (name LIKE ? OR lastname LIKE ? OR email LIKE ?)', "OK", false, true, "%#{search}%","%#{search}%","%#{search}%")
            else
                where('status=? and anonymous=? and active=?',"OK", false, true)
            end
        end
    end

    def update_geo_address
      self.geo_address = self.address1 + " " + address2 + " " + address3
    end
    
    def fullname
        [name, lastname, email].join(' ')        
    end

    def self.find_first_by_auth_conditions warden_conditions
      conditions = warden_conditions.dup
      if (email = conditions.delete(:email)).present?
        where(email: email.downcase).first
      elsif conditions.has_key?(:reset_password_token)
        where(reset_password_token: conditions[:reset_password_token]).first
      end
    end
    
end
