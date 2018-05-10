# rails-jsonapi-example

Small example API on Ruby on Rails using [JSONAPI::Resources](http://jsonapi-resources.com/).

## Description

This example API follows the JSON API specification. If you are familiar with it
then no much description is necessary and you can easily dive into the source.

Here is the list of all things of what it does:

1.  Receives and URL and saves it into the database.
2.  Parses the remote content using [Nokogiri](https://github.com/sparklemotion/nokogiri)
library and values of the allowed tags (`h1`, `h2`, `h3` and `a`) and stores
them in the database.
3.  Lists all stored pages.
4.  Shows a single page by its ID.
5.  Lists all stored tags for a specified page.

## Scaffold

Since we are using Ruby on Rails we don't need to start from scratch and simply
use `bundle`, `rails` and `rake` tools to do most of the work for us.

Here is the list of all commands used to generate our example scaffold:

```bash
# create a new Rails application
rails new rails-jsonapi-example --api
cd rails-jsonapi-example

# add gems using `bundle`
bundle add jsonapi-resources
bundle add nokogiri
bundle add minitest
bundle add webmock
# or just manually edit Gemfile and run `bundle update`

# models
rails generate model Page url:string
rails generate model PageTag name:string{3} value:string page:belongs_to
rake db:create
rake db:migrate

# controllers
rails generate jsonapi:controller Api::V1::Pages
rails generate jsonapi:controller Api::V1::PageTags

# JSONAPI::Resources
rails generate jsonapi:resource api::v1::page
rails generate jsonapi:resource api::v1::page_tag
```

After running commands above we are good to go.

## Running

As any other Ruby on Rails app:

```bash
rails server
```

## Routes

In order to get the list of all routes you can use `rake routes`. However the
most interesting ones will be:

```
api_v1_page_tags GET  /api/v1/pages/:page_id/tags(.:format) api/v1/page_tags#get_related_resources {:relationship=>"tags", :source=>"api/v1/pages"}
    api_v1_pages GET  /api/v1/pages(.:format)               api/v1/pages#index
                 POST /api/v1/pages(.:format)               api/v1/pages#create
     api_v1_page GET  /api/v1/pages/:id(.:format)           api/v1/pages#show
```

### Description

#### `POST` `/api/v1/pages`

Receives an URL, validates it and stores it into the database. The remote
content is parsed and values of the allowed tags (`h1`, `h2`, `h3` and `a`) are
also stored in the database.

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"data": {"type": "pages", "attributes": {"url": "https://example.com/" }}}' http://localhost:3000/api/v1/pages
```

#### `GET` `/api/v1/pages`

Lists all pages stored in the database.

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X GET http://localhost:3000/api/v1/pages
```

#### `GET` `/api/v1/pages/:id`

Shows the single page.

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X GET http://localhost:3000/api/v1/pages/1
```

#### `GET` `/api/v1/pages/:id/tags`

List all tags stored in the database for specified page.

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X GET http://localhost:3000/api/v1/pages/1/tags
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).
