#!/usr/bin/env ruby
# Generates `EimzoExample.xcodeproj` — a minimal iOS app that links the
# published EimzoSDK binary through Swift Package Manager.
#
# You normally don't need to run this: the generated project is committed and
# opens straight from a fresh clone. Re-run it after changing the project
# structure — a new source file, a renamed target, a different SDK version.
#
#   cd example/ios-swift && ruby generate-xcodeproj.rb
#
# Requires the xcodeproj gem:
#
#   gem install xcodeproj

require 'xcodeproj'
require 'fileutils'

ROOT        = __dir__
EXAMPLE_DIR = File.join(ROOT, 'EimzoExample')
PROJ_PATH   = File.join(ROOT, 'EimzoExample.xcodeproj')

SDK_PACKAGE_URL = 'https://github.com/peachdev-uz/eimzo-ios-sdk'
# 2.x: the licence became mandatory in 2.0 and the public API narrowed to
# EImzoView in 2.1. Anything below that does not match this example's code.
SDK_MIN_VERSION = '2.1.2'
EXAMPLE_VERSION = '2.1.2'

SOURCES = %w[EimzoExampleApp.swift ContentView.swift DeepLink.swift].freeze

SOURCES.each do |f|
  path = File.join(EXAMPLE_DIR, f)
  abort "✖ manba topilmadi: #{path}" unless File.exist?(path)
end

FileUtils.rm_rf(PROJ_PATH)
project = Xcodeproj::Project.new(PROJ_PATH)
project.root_object.attributes['LastUpgradeCheck'] = '1600'

target = project.new_target(:application, 'EimzoExample', :ios, '16.0')
target.build_configurations.each do |config|
  config.build_settings.merge!({
    'PRODUCT_BUNDLE_IDENTIFIER'  => 'uz.eimzo.example',
    'PRODUCT_NAME'               => '$(TARGET_NAME)',
    'CODE_SIGN_STYLE'            => 'Automatic',
    # Left empty on purpose — Xcode prompts for your own team on first open.
    'DEVELOPMENT_TEAM'           => '',
    'CODE_SIGN_ENTITLEMENTS'     => 'EimzoExample/EimzoExample.entitlements',
    'INFOPLIST_FILE'             => 'EimzoExample/Info.plist',
    'GENERATE_INFOPLIST_FILE'    => 'NO',
    'TARGETED_DEVICE_FAMILY'     => '1', # iPhone
    'IPHONEOS_DEPLOYMENT_TARGET' => '16.0',
    'SWIFT_VERSION'              => '5.9',
    'ENABLE_PREVIEWS'            => 'YES',
    'CURRENT_PROJECT_VERSION'    => '1',
    'MARKETING_VERSION'          => EXAMPLE_VERSION,
  })
end

# The group's `path` is 'EimzoExample', so file refs below are relative to it.
# Prefixing them again produces EimzoExample/EimzoExample/Foo.swift.
src_group = project.new_group('EimzoExample', 'EimzoExample')
SOURCES.each do |fname|
  target.add_file_references([src_group.new_file(fname)])
end
# Navigator only — both are wired through build settings, not a build phase.
src_group.new_file('Info.plist')
src_group.new_file('EimzoExample.entitlements')

# EimzoSDK comes from GitHub Releases as an xcframework; Xcode resolves and
# downloads it on first open, so a fresh clone needs nothing else.
pkg = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
pkg.repositoryURL = SDK_PACKAGE_URL
pkg.requirement   = { 'kind' => 'upToNextMajorVersion',
                      'minimumVersion' => SDK_MIN_VERSION }
project.root_object.package_references << pkg

product = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
product.package      = pkg
product.product_name = 'EimzoSDK'
target.package_product_dependencies << product

build_file = project.new(Xcodeproj::Project::Object::PBXBuildFile)
build_file.product_ref = product
target.frameworks_build_phase.files << build_file

project.save
puts "✔ #{PROJ_PATH}"
puts "  Xcode'da ochish: open #{PROJ_PATH}"
