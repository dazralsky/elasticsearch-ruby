# encoding: UTF-8

require 'test_helper'

module Elasticsearch
  module Test
    class UtilsTest < Minitest::Test
      include Elasticsearch::API::Utils

      context "Utils" do

        context "__escape" do

          should "encode Unicode characters" do
            assert_equal '%E4%B8%AD%E6%96%87', __escape('中文')
          end

          should "encode special characters" do
            assert_equal 'foo%20bar', __escape('foo bar')
          end

        end

        context "__listify" do

          should "create a list from single value" do
            assert_equal 'foo', __listify('foo')
          end

          should "create a list from an array" do
            assert_equal 'foo,bar', __listify(['foo', 'bar'])
          end

          should "create a list from multiple arguments" do
            assert_equal 'foo,bar', __listify('foo', 'bar')
          end

          should "ignore nil values" do
            assert_equal 'foo,bar', __listify(['foo', nil, 'bar'])
          end

        end

        context "__pathify" do

          should "create a path from single value" do
            assert_equal 'foo', __pathify('foo')
          end

          should "create a path from an array" do
            assert_equal 'foo/bar', __pathify(['foo', 'bar'])
          end

          should "ignore nil values" do
            assert_equal 'foo/bar', __pathify(['foo', nil, 'bar'])
          end

          should "ignore empty string values" do
            assert_equal 'foo/bar', __pathify(['foo', '', 'bar'])
          end

          should "encode special characters" do
            assert_equal 'foo/bar%5Ebam', __pathify(['foo', 'bar^bam'])
          end

        end

        context "__bulkify" do

          should "serialize array of hashes" do
            result = Elasticsearch::API::Utils.__bulkify [
              { :index =>  { :_index => 'myindexA', :_type => 'mytype', :_id => '1', :data => { :title => 'Test' } } },
              { :update => { :_index => 'myindexB', :_type => 'mytype', :_id => '2', :data => { :doc => { :title => 'Update' } } } },
              { :delete => { :_index => 'myindexC', :_type => 'mytypeC', :_id => '3' } }
            ]

            if RUBY_1_8
              lines = result.split("\n")

              assert_equal 5, lines.size
              assert_match /\{"index"\:\{/, lines[0]
              assert_match /\{"title"\:"Test"/, lines[1]
              assert_match /\{"update"\:\{/, lines[2]
              assert_match /\{"doc"\:\{"title"/, lines[3]
            else
              assert_equal <<-PAYLOAD.gsub(/^\s+/, ''), result
                {"index":{"_index":"myindexA","_type":"mytype","_id":"1"}}
                {"title":"Test"}
                {"update":{"_index":"myindexB","_type":"mytype","_id":"2"}}
                {"doc":{"title":"Update"}}
                {"delete":{"_index":"myindexC","_type":"mytypeC","_id":"3"}}
              PAYLOAD
            end
          end

          should "serialize arrays of strings" do
            result = Elasticsearch::API::Utils.__bulkify ['{"foo":"bar"}','{"moo":"bam"}']
            assert_equal <<-PAYLOAD.gsub(/^\s+/, ''), result
              {"foo":"bar"}
              {"moo":"bam"}
            PAYLOAD
          end

          should "serialize arrays of header/data pairs" do
            result = Elasticsearch::API::Utils.__bulkify [{:foo => "bar"},{:moo => "bam"},{:foo => "baz"}]
            assert_equal <<-PAYLOAD.gsub(/^\s+/, ''), result
              {"foo":"bar"}
              {"moo":"bam"}
              {"foo":"baz"}
            PAYLOAD
          end

        end

      end
    end
  end
end
