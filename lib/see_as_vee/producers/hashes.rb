module SeeAsVee
  module Producers
    class Hashes
      INTERNAL_PARAMS = %i|ungroup delimiter|.freeze
      NORMALIZER = ->(symbol, hash) { hash.map { |k, v| [k.public_send(symbol ? :to_sym : :to_s), v] }.to_h }.freeze
      HUMANIZER = lambda do |hash|
        hash.map do |k, v|
          [k.respond_to?(:humanize) ? k.humanize : k.to_s.sub(/\A_+/, '').tr('_', ' ').downcase, v]
        end.to_h
      end.freeze

      def initialize *args, **params
        @hashes = []
        @params = params
        add(*args)
      end

      def add *args
        @keys, @joined = [nil] * 2
        @hashes += degroup(args.flatten.select(&Hash.method(:===)), @params[:ungroup], @params[:delimiter] || ',')
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

      private

      def degroup hashes, columns, delimiter
        return hashes if (columns = [*columns]).empty?

        hashes.tap do |hs|
          hs.each do |hash|
            columns.each do |column|
              case c = hash.delete(column)
              when Array then c
              when String then c.split(delimiter)
              else [c.inspect]
              end.each.with_index(1) do |value, idx|
                hash["#{column}_#{idx}"] = value
              end
            end
          end
        end
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

        def csv *args, **params
          constructor_params, params = split_params(**params)
          result, = Hashes.new(*args, **constructor_params).to_sheet.produce csv: true, xlsx: false, **params
          result
        end

        def xlsx *args, **params
          constructor_params, params = split_params(**params)
          _, result = Hashes.new(*args, **constructor_params).to_sheet.produce csv: false, xlsx: true, **params
          result
        end

        # **NB** this method is NOT idempotent!
        def split_params **params
          [
            INTERNAL_PARAMS.each_with_object({}) do |param, acc|
              acc[param] = params.delete(param)
            end.reject { |_, v| v.nil? },
            params
          ]
        end
      end
    end
  end
end
