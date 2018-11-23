# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'

describe 'Unit test of Result value' do
  it 'should valid success status and message' do
    result = CodePraise::Value::Result.new(status: :ok, message: 'foo')

    _(result.status).must_equal :ok
    _(result.message).must_equal 'foo'
  end

  it 'should valid failure status and message' do
    result = CodePraise::Value::Result.new(status: :not_found, message: 'foo')

    _(result.status).must_equal :not_found
    _(result.message).must_equal 'foo'
  end

  it 'should report error for invalid status' do
    proc do
      CodePraise::Value::Result.new(status: :foobar, message: 'foo')
    end.must_raise ArgumentError
  end
end
