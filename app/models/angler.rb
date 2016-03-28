class Angler < ActiveRecord::Base
  has_many :lures
  has_secure_password
  
  def slug
    username.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|inst| inst.slug == slug}
  end
end