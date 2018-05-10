# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class Page < ApplicationRecord
  has_many :tags, class_name: 'PageTag'

  validates :url, url: true

  # The list of all allowed tags to be parsed
  ALLOWED_PARSE_TAGS = %w(h1 h2 h3 a)

  after_create :parse

  # Parses the remote page using the provided `url`.
  def parse
    doc = Nokogiri::HTML(open(self.url))

    ALLOWED_PARSE_TAGS.each do |tag|
      doc.css(tag).each do |t|
        create_tag(tag, t.content).save
      end
    end
  end

  private

  # Creates a `PageTag` instance and cleans its value.
  #
  # ==== Arguments
  #
  # * +name+ - Tag name.
  # * +value+ - Tag value.
  #
  # ==== Examples
  #
  #   create_tag('a', 'Hello World')
  #   create_tag('h1', 'Heading 1')
  def create_tag(name, value)
    tag       = PageTag.new
    tag.page  = self
    tag.name  = name
    tag.value = value
    tag.clean

    tag
  end
end
