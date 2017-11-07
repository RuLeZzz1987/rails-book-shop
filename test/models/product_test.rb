require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(title: 'My Book Title',
                          description: 'yyy',
                          image_url: 'zzz.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ['should be greater 0!'],
                 product.errors[:price]
    product.price = 0
    assert product.invalid?
    assert_equal ['should be greater 0!'],
                 product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url, idx)
    Product.new(
      title: "My Book Title #{idx}",
      description: 'yyy',
      image_url: image_url,
      price: 1
    )
  end

  test 'image url' do
    ok = %w[fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif]
    bad = %w[fred.doc fred.gif/more fred.gif.more]
    ok.each_with_index do |name, idx|
      assert new_product(name, idx).valid?, "#{name} shouldn't be invalid"
    end
    bad.each_with_index do |name, idx|
      assert new_product(name, idx).invalid?, "#{name} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title: products(:ruby).title,
                          description:
                              'yyy',
                          price:
                              1,
                          image_url:
                              'fred.gif')
    assert product.invalid?
    assert_equal ['has already been taken'], product.errors[:title]
  end
end
