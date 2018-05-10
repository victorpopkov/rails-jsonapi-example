# frozen_string_literal: true

require 'test_helper'

describe Page do
  before do
    @page     = Page.new
    @page.url = 'http://example.com/'

    # mock the request
    stub_request(:any, 'http://example.com/').
        to_return(status: 200, headers: {}, body: <<EOF
<!doctype html>
<html>
<head>
    <title>Example Domain</title>

    <meta charset="utf-8" />
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>

<body>
<div>
    <h1>Heading 1</h1>
    <h2>Heading 2</h2>
    <h3>Heading 3</h3>
    <p>This domain is established to be used for illustrative examples in documents. You may use this
    domain in examples without prior coordination or asking for permission.</p>
    <p><a href="http://www.iana.org/domains/example">More information...</a></p>
</div>
</body>
</html>
EOF
        )
  end

  describe 'running create_tag()' do
    it 'should return a new PageTag instance with both name and a cleaned value set' do
      # we call the private method
      expected = @page.send(:create_tag, 'a', '   Hello World!   ')

      assert_instance_of PageTag, expected
      assert 'a', expected.name
      assert 'Hello World!', expected.value
    end
  end

  describe 'running parse()' do
    it 'should extract allowed tags and store them in database' do
      p = Page.new
      p.url = 'http://example.com/'
      p.save

      assert 0, PageTag.where(page_id: p.id)
      p.parse
      assert 4, PageTag.where(page_id: p.id).length
    end
  end
end
