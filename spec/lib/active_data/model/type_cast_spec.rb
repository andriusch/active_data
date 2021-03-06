# encoding: UTF-8
require 'spec_helper'

describe 'typecasting' do
  let(:klass) do
    Class.new do
      include ActiveData::Model::Attributes
      attr_reader :name

      attribute :string, type: String
      attribute :integer, type: Integer
      attribute :float, type: Float
      attribute :big_decimal, type: BigDecimal
      attribute :boolean, type: Boolean
      attribute :array, type: Array
      attribute :date, type: Date
      attribute :datetime, type: DateTime
      attribute :time, type: Time
      attribute :time_zone, type: ActiveSupport::TimeZone
      attribute :uuid, type: ActiveData::UUID

      def initialize name = nil
        @attributes = self.class.initialize_attributes
        @name = name
      end
    end
  end

  subject{klass.new}

  context 'string' do
    specify{subject.tap{|s| s.string = 'hello'}.string.should == 'hello'}
    specify{subject.tap{|s| s.string = 123}.string.should == '123'}
    specify{subject.tap{|s| s.string = nil}.string.should == nil}
  end

  context 'integer' do
    specify{subject.tap{|s| s.integer = 'hello'}.integer.should == nil}
    specify{subject.tap{|s| s.integer = '123hello'}.integer.should == nil}
    specify{subject.tap{|s| s.integer = '123'}.integer.should == 123}
    specify{subject.tap{|s| s.integer = '123.5'}.integer.should == 123}
    specify{subject.tap{|s| s.integer = 123}.integer.should == 123}
    specify{subject.tap{|s| s.integer = 123.5}.integer.should == 123}
    specify{subject.tap{|s| s.integer = nil}.integer.should == nil}
    specify{subject.tap{|s| s.integer = [123]}.integer.should == nil}
  end

  context 'float' do
    specify{subject.tap{|s| s.float = 'hello'}.float.should == nil}
    specify{subject.tap{|s| s.float = '123hello'}.float.should == nil}
    specify{subject.tap{|s| s.float = '123'}.float.should == 123.0}
    specify{subject.tap{|s| s.float = '123.'}.float.should == nil}
    specify{subject.tap{|s| s.float = '123.5'}.float.should == 123.5}
    specify{subject.tap{|s| s.float = 123}.float.should == 123.0}
    specify{subject.tap{|s| s.float = 123.5}.float.should == 123.5}
    specify{subject.tap{|s| s.float = nil}.float.should == nil}
    specify{subject.tap{|s| s.float = [123.5]}.float.should == nil}
  end

  context 'big_decimal' do
    specify{subject.tap{|s| s.big_decimal = 'hello'}.big_decimal.should == nil}
    specify{subject.tap{|s| s.big_decimal = '123hello'}.big_decimal.should == nil}
    specify{subject.tap{|s| s.big_decimal = '123'}.big_decimal.should == BigDecimal.new('123.0')}
    specify{subject.tap{|s| s.big_decimal = '123.'}.big_decimal.should == nil}
    specify{subject.tap{|s| s.big_decimal = '123.5'}.big_decimal.should == BigDecimal.new('123.5')}
    specify{subject.tap{|s| s.big_decimal = 123}.big_decimal.should == BigDecimal.new('123.0')}
    specify{subject.tap{|s| s.big_decimal = 123.5}.big_decimal.should == BigDecimal.new('123.5')}
    specify{subject.tap{|s| s.big_decimal = nil}.big_decimal.should == nil}
    specify{subject.tap{|s| s.big_decimal = [123.5]}.big_decimal.should == nil}
  end

  context 'boolean' do
    specify{subject.tap{|s| s.boolean = 'hello'}.boolean.should == nil}
    specify{subject.tap{|s| s.boolean = 'true'}.boolean.should == true}
    specify{subject.tap{|s| s.boolean = 'false'}.boolean.should == false}
    specify{subject.tap{|s| s.boolean = '1'}.boolean.should == true}
    specify{subject.tap{|s| s.boolean = '0'}.boolean.should == false}
    specify{subject.tap{|s| s.boolean = true}.boolean.should == true}
    specify{subject.tap{|s| s.boolean = false}.boolean.should == false}
    specify{subject.tap{|s| s.boolean = 1}.boolean.should == true}
    specify{subject.tap{|s| s.boolean = 0}.boolean.should == false}
    specify{subject.tap{|s| s.boolean = nil}.boolean.should == nil}
    specify{subject.tap{|s| s.boolean = [123]}.boolean.should == nil}
  end

  context 'array' do
    specify{subject.tap{|s| s.array = [1, 2, 3]}.array.should == [1, 2, 3]}
    specify{subject.tap{|s| s.array = 'hello, world'}.array.should == ['hello', 'world']}
    specify{subject.tap{|s| s.array = 10}.array.should == nil}
  end

  context 'date' do
    let(:date) { Date.new(2013, 6, 13) }
    specify{subject.tap{|s| s.date = nil}.date.should == nil}
    specify{subject.tap{|s| s.date = '2013-06-13'}.date.should == date}
    specify{subject.tap{|s| s.date = '2013-55-55'}.date.should == nil}
    specify{subject.tap{|s| s.date = DateTime.new(2013, 6, 13, 23, 13)}.date.should == date}
    specify{subject.tap{|s| s.date = Time.new(2013, 6, 13, 23, 13)}.date.should == date}
  end

  context 'datetime' do
    let(:datetime) { DateTime.new(2013, 6, 13, 23, 13) }
    specify{subject.tap{|s| s.datetime = nil}.datetime.should == nil}
    specify{subject.tap{|s| s.datetime = '2013-06-13 23:13'}.datetime.should == datetime}
    specify{subject.tap{|s| s.datetime = '2013-55-55 55:55'}.datetime.should == nil}
    specify{subject.tap{|s| s.datetime = Date.new(2013, 6, 13)}.datetime.should == DateTime.new(2013, 6, 13, 0, 0)}
    specify{subject.tap{|s| s.datetime = Time.utc(2013, 6, 13, 23, 13).utc}.datetime.should == DateTime.new(2013, 6, 13, 23, 13)}
  end

  context 'time' do
    let(:time) { Time.utc(2013, 6, 13, 23, 13) }
    specify{subject.tap{|s| s.time = nil}.time.should == nil}
    # specify{subject.tap{|s| s.time = '2013-06-13 23:13'}.time.should == time}
    specify{subject.tap{|s| s.time = '2013-55-55 55:55'}.time.should == nil}
    specify{subject.tap{|s| s.time = Date.new(2013, 6, 13)}.time.should == Time.new(2013, 6, 13, 0, 0)}
    specify{subject.tap{|s| s.time = DateTime.new(2013, 6, 13, 23, 13)}.time.should == time}
  end

  context 'time_zone' do
    specify{subject.tap{|s| s.time_zone = nil}.time_zone.should be_nil}
    specify{subject.tap{|s| s.time_zone = Object.new}.time_zone.should be_nil}
    specify{subject.tap{|s| s.time_zone = Time.now}.time_zone.should be_nil}
    specify{subject.tap{|s| s.time_zone = 'blablabla'}.time_zone.should be_nil}
    specify{subject.tap{|s| s.time_zone = TZInfo::Timezone.all.first}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = 'Moscow'}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = '+4'}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = '-3'}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = '3600'}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = '-7200'}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = 4}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = -3}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = 3600}.time_zone.should be_a ActiveSupport::TimeZone}
    specify{subject.tap{|s| s.time_zone = -7200}.time_zone.should be_a ActiveSupport::TimeZone}
  end

  context 'uuid' do
    let(:uuid) { ActiveData::UUID.random_create }
    let(:uuid_tools) { UUIDTools::UUID.random_create }

    specify { uuid.as_json.should == uuid.to_s }
    specify { uuid.to_json.should == "\"#{uuid.to_s}\"" }
    specify { uuid.to_param.should == uuid.to_s }
    specify { uuid.to_query(:key).should == "key=#{uuid.to_s}" }

    specify{subject.tap{|s| s.uuid = nil}.uuid.should be_nil}
    specify{subject.tap{|s| s.uuid = Object.new}.uuid.should be_nil}
    specify{subject.tap{|s| s.uuid = uuid_tools}.uuid.should be_a ActiveData::UUID }
    specify{subject.tap{|s| s.uuid = uuid_tools}.uuid.should == uuid_tools}
    specify{subject.tap{|s| s.uuid = uuid}.uuid.should == uuid}
    specify{subject.tap{|s| s.uuid = uuid.to_s}.uuid.should == uuid}
    specify{subject.tap{|s| s.uuid = uuid.to_i}.uuid.should == uuid}
    specify{subject.tap{|s| s.uuid = uuid.hexdigest}.uuid.should == uuid}
    specify{subject.tap{|s| s.uuid = uuid.raw}.uuid.should == uuid}
  end
end