module Walkscore
  class Error < StandardError
  end

  InvalidApiKey = Class.new(Error)
  DailyQuotaExceeded = Class.new(Error)
  UnexpectedStatus = Class.new(Error)
  IpAddressBlocked = Class.new(Error)
  InvalidLatLong = Class.new(Error)
  InternalError = Class.new(Error)
  UnexpectedResponseCode = Class.new(Error)
end
