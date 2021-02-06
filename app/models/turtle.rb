class Snap
  class Turtle < Sprite
    attr_reader :stage, :thread
    # TODO: Add font and text rendering
    # TODO: Refactor to allow all sprites to run code

    def initialize(display, stage)
      super(display, 'turtle', x: 500, y: 500, size: 10)
      @stage = stage
    end

    def wait(time)
      stage.paint
      sleep time
    end
    alias_method :wt, :wait

    def run(code)
      return unless @thread.nil?

      @thread = Thread.new do
        sleep 0.1
        eval code
        @thread = nil
      end
    rescue => e
      puts e.full_message
    end

    def stop
      return if @thread.nil?

      @thread.kill
    rescue => e
      puts e.full_message
    ensure
      @thread = nil
    end
  end
end
