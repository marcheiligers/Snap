class Snap
  # Copy/Pasta, thanks, https://dev.to/pashagray/simple-pub-sub-pattern-oop-using-pure-ruby-49eh
  module Publisher
    def subscribe(subscriber)
      subscribers.push(subscriber)
    end

    def publish(event, *payload)
      handler = "on_#{event}".to_sym
      subscribers.each do |subscriber|
        subscriber.public_send(handler.to_sym, *payload) if subscriber.respond_to?(handler)
      end
    end

    def subscribers
      @subscribers ||= []
    end
  end
end
