require 'spec_helper'

describe Pxeger do
  describe "#generate" do
    [
      /^$/,
      /^\$/,
      /^\d{4}$/,
      /^\w{4}$/,
      /^\D{4}$/,
      /^\W{4}$/,
      /^\w{1,}$/,
      /^\w{1,2}$/,
      /^[\d]$/,
      /^[abc]+$/,
      /^[a|b]+$/,
      /^[^\W]+$/,
      /^[$-]+$/,
      /^[a-c]+$/,
      /^[a\-c]+$/,
      /^\d{1,3}(,\d{3})*$/,
      /^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$/,
      /^ab?$/,
      /^ab*$/,
      /^...$/,
      /^aa|bb$/,
      /^(a|b)$/,
      /^((a|b)c)$/,
      /^(()a)$/,
      /^(aa|bb)$/,
      /^(aa|bb(cc|dd))$/,
      /^(a(xx|yy)a|bb(cc|dd))$/,
      /^http:\/\/[a-z]{3,8}\.example\.com\/([a-z\d]+\/){3}$/,
      /(?:<(p|div) title="[^"]+">[^<]+<\/\1>)+/,
      /^[カコ][ッー]{1,3}?[フヒ]{1,3}[ィェー]{1,3}[ズス][クグュ][リイ][プブ]{1,3}[トドォ]{1,2}$/,
      /(aa|(bb|cc))\1\2/,
    ].each do |pattern|
      context "when the pattern is #{pattern.inspect}" do
        before { @generator = Pxeger.new(pattern) }
        it "should generate matching string", aggregate_failures: true do
          100.times do
            expect(@generator.generate).to match(pattern)
          end
        end
      end
    end
  end
end
