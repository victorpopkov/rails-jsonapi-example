# frozen_string_literal: true

class Api::V1::PageTagResource < JSONAPI::Resource
  immutable

  attributes :name, :value

  has_one :page
end
