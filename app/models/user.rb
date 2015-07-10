class User <ActiveRecord::Base
  # Need to fix slug when multiple login sources (FB + Oauth Identity) !!!
  include Slugable
  slugable_column :first_name
  
  has_many :user_books
  has_many :books, through: :user_books

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates_presence_of :first_name, :last_name
  validates :email, uniqueness: true

  has_attached_file :avatar, 
                    :styles => { :medium => "200x200>", :thumb => "100x100>" }, 
                    :default_url => "/images/:style/missing.png"
  has_attached_file :download,
                    :storage => :s3,
                    :s3_credentials => {:bucket => "bookself-avatars", :access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_KEY']}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      if auth.provider == "facebook"
        user.image = auth.info.image + "?type=large"
        user.token = auth.credentials.token
        user.expires_at = Time.at(auth.credentials.expires_at)
      end
      user.slug = user.generate_slug
      user.save!
    end
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(search)
    if search == ""
    elsif search
      key = "%#{search}%"
      where('first_name LIKE :search OR last_name LIKE :search', search: key)
    else
    end
  end

  def same_books(user)
    current_user_books = self.books.uniq
    user_books         = user.books.uniq
    same_books = current_user_books & user_books
  end

  def number_of_same_books(user)
    current_user_books = self.books.uniq
    user_books         = user.books.uniq
    different_books    = (current_user_books - user_books).count
    if different_books < 0
      different_books =  different_books*-1
    end 
    same_books_total = current_user_books.count - different_books
    return same_books_total
  end

  
end