# frozen_string_literal: true

require 'test_helper'

describe PageTag do
  before do
    @tag = PageTag.new
  end

  describe 'running clean()' do
    it 'should strip leading and trailing whitespaces from the value' do
      @tag.value = '   test   '
      @tag.clean
      assert 'test', @tag.value
    end
  end
end
