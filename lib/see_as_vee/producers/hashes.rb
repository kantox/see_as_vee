module SeeAsVee
  module Producers
    class Hashes
      NORMALIZER = ->(symbol, hash) { hash.map { |k, v| [k.public_send(symbol ? :to_sym : :to_s), v] }.to_h }.freeze
      HUMANIZER = lambda do |hash|
        hash.map do |k, v|
          [k.respond_to?(:humanize) ? k.humanize : k.to_s.sub(/\A_+/, '').tr('_', ' ').downcase, v]
        end.to_h
      end.freeze

      def initialize *args, **params
        @hashes = []
        add(*args, **params)
      end

      def add *args, **params
        @keys, @joined = [nil] * 2

        @hashes << params unless params.size.zero?
        @hashes |= args.flatten.select(&Hash.method(:===))
        normalize!(false)
      end

      def normalize symbol = true # to_s otherwise
        @hashes.map(&NORMALIZER.curry[symbol])
      end

      def normalize! symbol = true # to_s otherwise
        @hashes.map!(&NORMALIZER.curry[symbol])
        self
      end

      def humanize
        @hashes.map(&HUMANIZER)
      end

      def humanize!
        @hashes.map!(&HUMANIZER)
        self
      end

      def join
        return @joined if @joined

        @joined = @hashes.map { |hash| keys.zip([nil] * keys.size).to_h.merge hash }
      end

      def keys
        @keys ||= @hashes.map(&:keys).reduce(&:|)
      end

      def to_sheet
        SeeAsVee::Sheet.new(humanize!.join.map(&:values).unshift(keys))
      end

      class << self
        def join *args, normalize: :human
          Hashes.new(*args).join.tap do |result|
            case normalize
            when :humanize, :human, :pretty then result.map!(&HUMANIZER)
            when :string, :str, :to_s then result.map!(&NORMALIZER.curry[false])
            when :symbol, :sym, :to_sym then result.map!(&NORMALIZER.curry[true])
            end
          end
        end

        def csv *args
          result, = Hashes.new(*args).to_sheet.produce
          result
        end

        def xlsx *args
          _, result = Hashes.new(*args).to_sheet.produce csv: false, xlsx: true
          result
        end
      end
    end
  end
end
