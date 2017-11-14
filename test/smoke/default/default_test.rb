# # encoding: utf-8

# Inspec test for recipe win_elasticsearch::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

describe service('elasticsearch-service-x64') do
  it { should be_enabled }
  it { should be_running }
end
