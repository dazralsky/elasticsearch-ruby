require 'test_helper'

module Elasticsearch
  module Test
    class PercolateTest < Minitest::Test

      context "Percolate" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raises ArgumentError do
            subject.percolate :type => 'bar', :body => {}
          end
        end

        should "require the :body argument" do
          assert_raises ArgumentError do
            subject.percolate :index => 'bar'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal 'foo/bar/_percolate', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:doc][:foo]
            true
          end.returns(FakeResponse.new)

          subject.percolate :index => 'foo', :type => 'bar', :body => { :doc => { :foo => 'bar' } }
        end

      end

    end
  end
end
