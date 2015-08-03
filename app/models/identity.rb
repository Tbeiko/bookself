class Identity < OmniAuth::Identity::Models::ActiveRecord
  validates_presence_of :first_name, :last_name, :email
  has_secure_password validations: false
  validates :password, presence: true, on: :create, length: {minimum: 6}
end