class Snap
  class Executor
    attr_reader :actor, :thread, :stage

    def initialize(stage)
      @stage = stage
      @actor = stage.actors.first
    end

    # Globals
    def wait(time = 0.01)
      stage.paint
      sleep time
    end
    alias_method :wt, :wait

    def add_sprite(name)
      normalized_name = name.to_s.downcase
      @actor = Sprite.new(stage.parent.display, normalized_name, x: 500, y: 500, size: 10)
      stage.add_actor(@actor)
      stage.paint
      wait
    end
    alias_method :as, :add_sprite

    def using(name)
      normalized_name = name.to_s.downcase
      actor = stage.actors.detect { |a| a.name == normalized_name }
      if actor
        @actor = actor
      else
        raise "Can't find sprite with name #{name}"
      end
    end

    # Internal
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
        drawable = actor.send(name, *args)
        stage.add_drawable(drawable) if drawable && drawable.is_a?(Drawable)
        stage.paint
        wait
      end
    rescue => e
      puts e.full_message
      super(name, *args)
    end
  end
end
