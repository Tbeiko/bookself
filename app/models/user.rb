class User <ActiveRecord::Base
  before_save :generate_slug

  validates_presence_of :first_name, :last_name
  validates :email, uniqueness: true  
  
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



  has_attached_file :avatar, 
                    :styles => { :medium => "200x200>", :thumb => "100x100>" }, 
                    :default_url => ""
  has_attached_file :cover, 
                    :styles => { :medium => "768x", :small => "400x" }, 
                    :default_url => ""
  has_attached_file :download,
                    :storage => :s3,
                    :s3_credentials => {:bucket => "bookself-avatars", :access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_KEY']}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
  
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
      user.random_color
      user.save!
    end
    # This is here so that the "provider" is not taken into account when seraching for users.
    # This way, users from different providers will not have the same slug.
    u = User.last
    u.generate_slug
    u.save!
    return User.where(provider: auth.provider, uid: auth.uid).first
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

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.first_name.to_s + self.last_name.to_s)
    object = User.find_by slug: the_slug
    count = 2
      while object && object !=self
        the_slug = append_suffix(the_slug, count)
        object = self.class.find_by slug: the_slug
        count += 1 
      end
    self.slug = the_slug.downcase
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      return str.split('-').slice(0...-1).join('-') + "-" + count.to_s
    else
      return str + "-" + count.to_s
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
    str.gsub! /-+/, '-'
    str.gsub! /^-+|-+$/, ''
    str.downcase
  end

  def random_color
    self.color = ["#80b891", "#f89f81", "#586576", "#f0d2a8"].sample
  end
end