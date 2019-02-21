class Reaction < ActiveRecord::Base
  # Add validation helpers here
  validates :title, :reaction_detail, presence: true

  # Add associations here
  belongs_to :medication

  # Create slug methods
  def slug
    Medication.find_by(id: self.medication_id).name.downcase.gsub(" ","-") << "-#{id}"
  end

  def self.find_by_slug(slug)
    self.all.find {|r| r.slug == slug}
  end
end