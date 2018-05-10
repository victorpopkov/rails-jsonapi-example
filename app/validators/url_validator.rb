# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  RESERVED_OPTIONS = [:schemes, :no_local]

  def initialize(options)
    options.reverse_merge!(schemes: %w(http https))
    options.reverse_merge!(message: 'must be a valid URL')
    options.reverse_merge!(user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36')

    super(options)
  end

  def validate_each(record, attribute, value)
    return if url_valid?(value)

    record.errors[attribute] << options[:message]
  end

  private

  # Checks whether the provided value matches the URL format.
  def url_valid?(url)
    schemes = [*options.fetch(:schemes)].map(&:to_s)
    uri     = URI.parse(url)
    uri && uri.host && schemes.include?(uri.scheme) && uri.host.include?('.')
  end
end
