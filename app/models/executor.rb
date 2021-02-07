class Snap
  class Executor
    attr_reader :actor, :thread, :stage

    def initialize(actor, stage)
      @actor = actor
      @stage = stage
    end

    def wait(time)
      stage.paint
      sleep time
    end
    alias_method :wt, :wait

    def exec(code)
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

    def running?
      !@thread.nil?
    end

    def method_missing(name, *args)
      # puts name
      # puts actor.inspect
      # puts actor.respond_to?(name)
      if actor.respond_to?(name)
        object = actor.send(name, *args)
        puts object.inspect
        puts "Drawable? #{object.is_a?(Drawable)}"
        stage.add(object) if object && object.is_a?(Drawable)
        stage.paint
        wait 0.01
      end
    rescue => e
      puts e.full_message
      super(name, *args)
    end
  end
end
