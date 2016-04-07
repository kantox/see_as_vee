require 'spec_helper'

describe SeeAsVee::Producers::Hashes do
  let!(:input) do
    [
      { a: 42, 'b' => :string },
      { a: 42, hello_world: 42 },
      { 'a' => :string, b: 42 }
    ]
  end
  let!(:output_sym) do
    [
      { a: 42, b: :string, hello_world: nil },
      { a: 42, b: nil, hello_world: 42 },
      { a: :string, b: 42, hello_world: nil }
    ]
  end
  let!(:output_str) do
    [
      { 'a' => 42, 'b' => :string, 'hello world' => nil },
      { 'a' => 42, 'b' => nil, 'hello world' => 42 },
      { 'a' => :string, 'b' => 42, 'hello world' => nil }
    ]
  end
  it 'joins hashes properly' do
    expect(SeeAsVee::Producers::Hashes.join(input, normalize: :sym)).to eq output_sym
    expect(SeeAsVee::Producers::Hashes.join(input, normalize: :humanize)).to eq output_str
  end
  it 'produces a proper sheet' do
    expect(SeeAsVee::Producers::Hashes.new(input).to_sheet).to be_is_a SeeAsVee::Sheet
  end
  it 'produces a proper csv' do
    f = SeeAsVee.csv(input)
    expect(f).to be_is_a Tempfile
    expect(f.read).to eq "a,b,hello world\n42,string,\n42,,42\nstring,42,\n"
  end
  it 'produces a proper xlsx' do
    f = SeeAsVee.xlsx(input)
    expect(f).to be_is_a Tempfile
  end
end
