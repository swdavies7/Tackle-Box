class Lure < ActiveRecord::Base
  belongs_to :tackle_box
  def slug
    name.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|inst| inst.slug == slug}
  end
end