def make_concurrent_calls(object, method, options={})
  options.reverse_merge!(count: 2)

  # For postgresql we need to disconnect before forking
  # and for other databases, it won't hurt.
  ActiveRecord::Base.connection.disconnect!

  processes = options[:count].times.map do |i|
    ForkBreak::Process.new do |breakpoints|
      # We need to reconnect after forking
      ActiveRecord::Base.establish_connection

      # Add a breakpoint after invoking the method
      original_method = object.method(method)
      object.stub(method) do |*args|
        value = original_method.call(*args)
        breakpoints << method
        value
      end

      object.send(method)
    end
  end
  processes.each { |process| process.run_until(method).wait }
  processes.each { |process| process.finish.wait }

  # The parent process also needs a new connection
  ActiveRecord::Base.establish_connection
end
