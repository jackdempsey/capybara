module Capybara
  module RSpecMatchers
    class HaveSelector
      def initialize(*args)
        @args = args
      end

      def matches?(actual)
        @actual = wrap(actual)
        @actual.has_selector?(*@args)
      end

      def does_not_match?(actual)
        @actual = wrap(actual)
        @actual.has_no_selector?(*@args)
      end

      def failure_message_for_should
        if normalized.failure_message
          normalized.failure_message.call(@actual)
        else
          "expected #{selector_name} to return something"
        end
      end

      def failure_message_for_should_not
        "expected #{selector_name} not to return anything"
      end

      def selector_name
        name = "#{normalized.name} #{normalized.locator.inspect}"
        name << " with text #{normalized.options[:text].inspect}" if normalized.options[:text]
        name
      end

      def wrap(actual)
        if actual.respond_to?("has_selector?")
          actual
        else
          Capybara.string(actual.to_s)
        end
      end

      def normalized
        @normalized ||= Capybara::Selector.normalize(*@args)
      end
    end

    def have_selector(*args)
      HaveSelector.new(*args)
    end

    def have_xpath(*args)
      HaveSelector.new(:xpath, *args)
    end

    def have_css(*args)
      HaveSelector.new(:css, *args)
    end
  end
end