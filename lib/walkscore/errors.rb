module Walkscore
  class ArgumentError < ::ArgumentError
  end

  class Error < ::RuntimeError
  end

  InvalidApiKey = Class.new(ArgumentError)
  DailyQuotaExceeded = Class.new(Error)
  UnexpectedStatus = Class.new(Error)
  IpAddressBlocked = Class.new(Error)
  InvalidLatLong = Class.new(ArgumentError)
  InternalError = Class.new(Error)
  UnexpectedResponseCode = Class.new(Error)
end
