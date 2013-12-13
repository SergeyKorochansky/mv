class ErrorHandler
  def self.handle(ex)
    $stderr.puts ex.message
    if defined? ex.errno
      exit ex.errno.to_i
    else
      exit 1
    end
  end
end