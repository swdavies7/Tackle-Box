class TackleBox < ActiveRecord::Base
  has_many :lures
  belongs_to :angler

  def slug
    name.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|inst| inst.slug == slug}
  end
end