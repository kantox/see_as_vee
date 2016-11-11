require 'spec_helper'

describe SeeAsVee::Helpers do
  context 'File Types' do
    subject :file_with_types do
      [
        [File.join(%w(spec fixtures velocity.xlsx)), :xlsx],
        [File.join(%w(spec fixtures velocity.csv)), :csv],
        ["a,b,c\n1,2,3", :csv]
      ]
    end

    it 'properly determines file types without filemagick gem' do
      check_them
    end

    it 'proceeds successfully without filemagick stub' do
      Kernel.send(:remove_const, 'FileMagick') if Kernel.const_defined?('FileMagick')
      check_them
    end

    private

    def check_them
      subject.map do |f, matcher|
        [SeeAsVee::Helpers.file_with_type(f), matcher]
      end.each do |(_, type), matcher|
        expect(type).to eq(matcher)
      end
    end
  end
end
