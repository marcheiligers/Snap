class Snap
  class Sprite
    module Input
      def ask(question, stage) # HACK: Executor passes in the stage
        value = nil

        stage.parent.display.sync_exec do
          value = StringDialog.new(self, question, stage.parent.parent).open
        end

        value
      end
    end
  end
end