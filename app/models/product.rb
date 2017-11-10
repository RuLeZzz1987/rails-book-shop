class Product < ActiveRecord::Base
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1,
                                    message: 'should be greater 0!' }
  validates :title, length: { minimum: 3, maximum: 30 }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: /\.(gif|jpg|png)\Z/i,
    message: 'URL should be GIF, JPG or PNG.'
  }

  def self.latest
    Product.order(:updated_at).last
  end

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      true
    else
      errors.add(:base, 'line items are not empty')
      false
    end
  end
end
