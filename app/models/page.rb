# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class Page < ApplicationRecord
  ALLOWED_PARSE_TAGS = %w(h1 h2 h3 a)
  USER_AGENT         = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36'

  has_many :tags, class_name: 'PageTag'

  validates :url, url: true

  after_create :parse

  # Parses the remote page using the provided `url`.
  def parse
    html = open(self.url, 'User-Agent' => USER_AGENT)
    doc  = Nokogiri::HTML(html)

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
  #
  def create_tag(name, value)
    tag       = PageTag.new
    tag.page  = self
    tag.name  = name
    tag.value = value
    tag.clean

    tag
  end
end
