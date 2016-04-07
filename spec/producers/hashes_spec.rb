require 'spec_helper'

describe SeeAsVee::Producers::Hashes do
  it 'joins hashes properly' do
    input = [
      { a: 42, 'b' => :string },
      { a: 42, c: 42 },
      { 'a' => :string, b: 42 }
    ]
    output_sym = [
      { a: 42, b: :string, c: nil },
      { a: 42, b: nil, c: 42 },
      { a: :string, b: 42, c: nil }
    ]
    output_str = [
      { 'a' => 42, 'b' => :string, "c" => nil },
      { 'a' => 42, 'b' => nil, 'c' => 42 },
      { 'a' => :string, 'b' => 42, 'c' => nil }
    ]
    expect(SeeAsVee::Producers::Hashes.join(input)).to eq output_str
    expect(SeeAsVee::Producers::Hashes.join(input, normalize: :sym, humanize: false)).to eq output_sym
  end
end
