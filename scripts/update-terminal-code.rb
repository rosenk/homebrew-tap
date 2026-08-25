#!/usr/bin/env ruby

require "json"
require "net/http"
require "pathname"
require "uri"

MANIFEST_URI = URI("https://tode.sh/install/latest.json")
FORMULA = Pathname(__dir__).join("..", "Formula", "terminal-code.rb").expand_path

response = Net::HTTP.get_response(MANIFEST_URI)
abort "manifest request failed: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

manifest = JSON.parse(response.body)
release = manifest.fetch("version")
abort "invalid release version: #{release.inspect}" unless release.match?(/\Av\d+\.\d+\.\d+\z/)

platforms = %w[linux-arm64 linux-x64].to_h do |target|
  [target, manifest.dig("platforms", target)]
end

platforms.each_value do |build|
  abort "release manifest is missing a Linux build" unless build
  uri = URI(build.fetch("url"))
  abort "unexpected release URL: #{uri}" unless uri.scheme == "https" && uri.host == "tode-releases.zenbu-labs.workers.dev"
  abort "invalid SHA-256 for #{uri}" unless build.fetch("sha256").match?(/\A[0-9a-f]{64}\z/)
end

contents = FORMULA.read
version = release.delete_prefix("v")
current_version = contents[/^  version "([^"]+)"$/, 1]
contents.sub!(/^  revision \d+\n/, "") if current_version != version
contents.sub!(/^  version ".*"$/, %(  version "#{version}"))

platforms.each do |target, build|
  block = /(    url ")[^"]+\/tode-#{target}\.tar\.gz("\n    sha256 ")[0-9a-f]+(")/
  replacement = "\\1#{build.fetch("url")}\\2#{build.fetch("sha256")}\\3"
  abort "could not update #{target} formula block" unless contents.sub!(block, replacement)
end

FORMULA.write(contents)
