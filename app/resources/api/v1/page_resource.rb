# frozen_string_literal: true

class Api::V1::PageResource < JSONAPI::Resource
  attributes :url

  has_many :tags, class_name: 'PageTag'

  filter :url
end
