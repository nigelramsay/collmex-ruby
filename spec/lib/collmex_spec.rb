require 'spec_helper'
require 'yaml'
require 'collmex'
require "vcr"
require "pry"



describe Collmex do
  it {should respond_to :username}
  it {should respond_to :password}
  it {should respond_to :customer_id}
end


describe "CollmexIntegration" do

  before(:each) do 
    Collmex.setup_login_data
  end

  after(:each) do
    Collmex.reset_login_data
  end

  it "should build sample output" do

    request = Collmex::Request.new

    request.add_command Collmex::Api::CustomerGet.new(customer_id: 9999)
    request.add_command Collmex::Api::AccdocGet.new()
    request.add_command Collmex::Api::AccdocGet.new(accdoc_id: 1)

    response = ""
    VCR.use_cassette('standard_request') do
      response = request.execute
    end
    #ap CSV.parse(response,Collmex.csv_opts)
  end

  it "should make hashes as response" do
    Collmex::Request.any_instance.stub(:execute)
    request = Collmex::Request.run do
      enqueue :accdoc_get
    end
  end
end


