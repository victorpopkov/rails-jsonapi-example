# frozen_string_literal: true

class PageTag < ApplicationRecord
  belongs_to :page

  TAG_VALUE_MAX_LENGTH = 255

  def clean
    self.value = self.value.to_s.strip[0...TAG_VALUE_MAX_LENGTH]
  end
end
