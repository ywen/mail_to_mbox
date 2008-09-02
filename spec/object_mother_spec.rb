require File.dirname(__FILE__) + '/spec_helper'

describe ObjectMother::ValidAttributeDefinitionsForModels, "valid attribute method macro" do
  attr_reader :container, :model_name, :sample_attributes
  before :each do
    @container         = Class.new do
      extend ObjectMother::ValidAttributeDefinitionsForModels
    end
    @model_name        = :does_not_matter
    @sample_attributes = {:foo => 'bar', :baz => 'quux'}
  end

  it "adds a singleton method which exposes the passed in attributes" do
    valid_attributes_are_defined_for(model_name).should be_false

    lambda {
      container.define_valid_attributes_for model_name do
        sample_attributes
      end
    }.should_not raise_error(NoMethodError)

    valid_attributes_are_defined_for(model_name).should be_true
    container.valid_attributes_for(model_name).should == sample_attributes
  end

  it "allows overrides to be passed in" do
    overrides = {:foo => 'this value has been changed'}
    container.define_valid_attributes_for model_name do
      sample_attributes
    end

    expected_attributes_with_overrides = sample_attributes.merge(overrides)
    container.valid_attributes_for(model_name, overrides).should == expected_attributes_with_overrides
  end

  private
    def valid_attributes_are_defined_for(model_name)
      !container.valid_attributes_for(model_name).empty?
    end

  describe ObjectMother::ModelBuilder do
      class Group
          attr_accessor :name, :display_name
          def initialize(params={})
              name = params[:name]
              display_name = params[:display_name]
          end
      end
    before :each do
      @model_name        = :group
      @sample_attributes = {:name => 'does not matter', :display_name => 'does not matter'}

      container.class_eval do
        extend ObjectMother::ModelBuilder
        extend ObjectMother::ModelBuildOrCreate
      end

      container.define_valid_attributes_for @model_name do
        @sample_attributes
      end
    end

    it "wraps valid attributes when creating instances of a model" do
      # Sanity check
      container.valid_attributes_for(model_name).should == sample_attributes
      model = nil
      lambda {
        model = container.build(model_name)
      }.should_not raise_error(NameError)
    
      model.should be_kind_of(Group)
      sample_attributes.each_pair do |attribute_name, attribute_value|
        model.send(attribute_name).should == attribute_value
      end
    end
  end
end
