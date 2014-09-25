RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

require 'simplecov' and SimpleCov.start { add_filter "/test|test_/" } if ENV["COVERAGE"]

require 'minitest/autorun'
require 'shoulda-context'
require 'mocha/setup'

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch'
RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

require '../elasticsearch-transport/lib/elasticsearch/transport/extensions/test_cluster'
require '../elasticsearch-transport/test/test_extensions'

module Elasticsearch
  module Test
    class IntegrationTestCase < Minitest::Test
      extend IntegrationTestStartupShutdown

      shutdown { Elasticsearch::TestCluster.stop if ENV['SERVER'] && started? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end
  end

  module Test
    class ProfilingTest < Minitest::Test
      extend IntegrationTestStartupShutdown
      extend ProfilingTestSupport

      shutdown { Elasticsearch::TestCluster.stop if ENV['SERVER'] && started? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end
  end
end
