# frozen_string_literal: true

module Fixtures
  def self.read(name)
    File.read("./spec/fixtures/#{name}")
  end
end
