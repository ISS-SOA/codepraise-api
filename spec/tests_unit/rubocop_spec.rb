# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'

JSON_FORMAT_COMMAND = 'rubocop  --except Metrics -f j 2>&1'
REPO_PATH = 'app/infrastructure/git/repostore/znjWpkQzvSU8ZnQ82oXCbLVIO6X5L69XkZuDuN6aKaw='
FILE_PATH = 'Gemfile'

describe 'Rubucop Module Unit Test' do
  describe CodePraise::Rubocop::Command do
    it 'should make right rubocop command' do
      command = CodePraise::Rubocop::Command.new
        .target('/')
        .except('Metrics')
        .format('json')
        .with_stderr_output
        .full_command

      _(command).must_equal JSON_FORMAT_COMMAND
    end
  end

  describe CodePraise::Rubocop::Reporter do
    it 'should return rubcop result with hash format' do
      rubocop_reporter = CodePraise::Rubocop::Reporter.new(REPO_PATH)
      _(rubocop_reporter.report).must_be_kind_of Hash
      _(rubocop_reporter.report.keys).wont_be_empty
      _(rubocop_reporter.report[FILE_PATH]).wont_be_nil
    end
  end
end
