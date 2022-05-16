module SpreeMobility
  module_function

  # Returns the version of the currently loaded SpreeMobility as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 1
    MINOR = 4
    TINY  = 0
    PRE   = nil # 'beta'

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
