require 'spec_helper'

describe SeeAsVee::Producers::Hashes do
  let(:input) do
    [
      { a: 42, 'b' => :string },
      { a: 42, hello_world: 42 },
      { 'a' => :string, b: 42 }
    ]
  end
  let(:input_grouped_string) do
    [
      { name: 'Aleksei', value: 42, nicks: 'matiushkin,mudasobwa,am-kantox' },
      { name: 'Saverio', value: 3.14, nicks: 'trioni,rewritten,saverio-kantox' }
    ]
  end
  let(:input_grouped_array) do
    [
      { name: 'Aleksei', value: 42, nicks: %w|matiushkin mudasobwa am-kantox| },
      { name: 'Saverio', value: 3.14, nicks: %w|trioni rewritten saverio-kantox| }
    ]
  end
  let(:output_sym) do
    [
      { a: 42, b: :string, hello_world: nil },
      { a: 42, b: nil, hello_world: 42 },
      { a: :string, b: 42, hello_world: nil }
    ]
  end
  let(:output_str) do
    [
      { 'a' => 42, 'b' => :string, 'hello world' => nil },
      { 'a' => 42, 'b' => nil, 'hello world' => 42 },
      { 'a' => :string, 'b' => 42, 'hello world' => nil }
    ]
  end
  let(:same_lines) do
    [{ a: 'b' }, { a: 'b' }, { c: 'd' }]
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
  it 'produces a proper csv for MS Excel' do
    f = SeeAsVee.csv(input, ms_excel: true)
    expect(f).to be_is_a Tempfile
    expect(
      File.open(f.path, "rb:BOM|UTF-16LE") do |f|
        break f.read.encode(Encoding::UTF_8)
      end).to eq("a,b,hello world\n42,string,\n42,,42\nstring,42,\n")
  end
  it 'accepts params while producing csv' do
    f = SeeAsVee.csv(input, col_sep: "\t")
    expect(f).to be_is_a Tempfile
    expect(f.read).to eq "a\tb\thello world\n42\tstring\t\n42\t\t42\nstring\t42\t\n"
  end
  it 'properly handles “ungroup” param for strings' do
    f = SeeAsVee.csv(input_grouped_string, ungroup: :nicks)
    expect(f).to be_is_a Tempfile
    expect(f.read).to eq "name,value,nicks 1,nicks 2,nicks 3\nAleksei,42,matiushkin,mudasobwa,am-kantox\nSaverio,3.14,trioni,rewritten,saverio-kantox\n"
  end
  it 'properly handles “ungroup” param for arrays' do
    f = SeeAsVee.csv(input_grouped_array, ungroup: :nicks)
    expect(f).to be_is_a Tempfile
    expect(f.read).to eq "name,value,nicks 1,nicks 2,nicks 3\nAleksei,42,matiushkin,mudasobwa,am-kantox\nSaverio,3.14,trioni,rewritten,saverio-kantox\n"
  end
  it 'produces a proper xlsx' do
    f = SeeAsVee.xlsx(input)
    expect(f).to be_is_a Tempfile
  end
  it 'properly handles the same lines' do
    result = SeeAsVee.csv(same_lines).read
    expect(result).to eq("a,c\nb,\nb,\n,d\n")
  end
end
