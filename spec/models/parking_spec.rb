require 'rails_helper'

# context 和 describe 作用一模一样，单纯只是分类组织而已，没有实际作用
# 1. 建立测试资料
# 2. 执行程序
# 3. 检查结果
RSpec.describe Parking, type: :model do
  describe '.validate_end_at_with_amount' do
    before do
      @parking = Parking.new( :parking_type => "guest", :start_at => Time.now - 6.hours)
    end

    it "is invalid without amount" do
      @parking.end_at = Time.now
      expect( @parking ).to_not be_valid
    end

    it "is invalid without end_at" do
      @parking.amount = 999
      expect( @parking ).to_not be_valid
    end
  end

  describe ".calculate_amount" do
    before do
      @time = Time.new(2017, 12, 13, 2, 0, 0)
    end

    context "guest" do
      before do
        @parking = Parking.new( :parking_type => 'guest', :user => @user, :start_at => @time )
      end

      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(200)
      end

      it "60 mins should be ¥2" do
        @parking.end_at = @time + 60.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(200)
      end

      it "61 mins should be ¥3" do
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(300)
      end

      it "90 mins should be ¥3" do
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(300)
      end

      it "120 mins should be ¥4" do
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(400)
      end
    end

    context "short-term" do
      before do
        @user = User.create( :email => 'test@example.com', :password => '123456789' )
        @parking = Parking.new( :parking_type => 'short-term', :user => @user, :start_at => @time )
      end

      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(200)
      end

      it "60 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(200)
      end

      it "61 mins should be ¥2.5" do
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(250)
      end

      it "90 mins should be ¥2.5" do
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(250)
      end

      it "120 mins should be ¥3" do
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(300)
      end
    end

    context "long-term" do
      before do
        @user = User.create( :email => 'test@example.com', :password => '123456789' )
        @parking = Parking.new( :parking_type => 'long-term', :user => @user, :start_at => @time )
      end

      it "3 hours should be ¥12" do
        @parking.end_at = @time + 3.hours
        @parking.calculate_amount
        expect( @parking.amount ).to eq(1200)
      end

      it "6 hours should be ¥12" do
        @parking.end_at = @time + 6.hours
        @parking.calculate_amount
        expect( @parking.amount ).to eq(1200)
      end

      it "23 hours should be ¥16" do
        @parking.end_at = @time + 23.hours
        @parking.calculate_amount
        expect( @parking.amount ).to eq(1600)
      end

      it "24 hours should be ¥16" do
        @parking.end_at = @time + 24.hours
        @parking.calculate_amount
        expect( @parking.amount ).to eq(1600)
      end

      it "25 hours should be ¥28" do
        @parking.end_at = @time + 25.hours
        @parking.calculate_amount
        expect( @parking.amount ).to eq(2800)
      end

      it "48 hours should be ¥32" do
        @parking.end_at = @time + 48.hours
        @parking.calculate_amount
        expect( @parking.amount ).to eq(3200)
      end
    end
  end
end
