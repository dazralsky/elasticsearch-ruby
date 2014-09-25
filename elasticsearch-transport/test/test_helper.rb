RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

require 'rubygems' if RUBY_1_8

require 'simplecov' and SimpleCov.start { add_filter "/test|test_/" } if ENV["COVERAGE"]

# Register `at_exit` handler for integration tests shutdown.
# MUST be called before requiring `test/unit`.


require 'minitest/autorun'
require 'shoulda-context'
require 'mocha/setup'
require 'ansi/code'

require File.expand_path('../test_extensions', __FILE__)

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch-transport'
require 'elasticsearch/transport/extensions/test_cluster'
require 'logger'

RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

module Elasticsearch
  module Test
    class IntegrationTestCase < MiniTest::Spec
      extend IntegrationTestStartupShutdown

      shutdown { Elasticsearch::TestCluster.stop if ENV['SERVER'] && started? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end
  end

  module Test
    class ProfilingTest < MiniTest::Spec
      extend IntegrationTestStartupShutdown
      extend ProfilingTestSupport

      shutdown { Elasticsearch::TestCluster.stop if ENV['SERVER'] && started? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end
  end
end

at_exit { Elasticsearch::Test::IntegrationTestCase.__run_at_exit_hooks }