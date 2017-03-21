module HueHome
  class Error < StandardError; end

  class UnauthorizedUser < Error; end
  class InvalidJSON < Error; end
  class ResourceNotAvailable < Error; end
  class MethodNotAvailable < Error; end
  class MissingBody < Error; end
  class ParameterNotAvailable < Error; end
  class InvalidValueForParameter < Error; end
  class ParameterNotModifiable < Error; end
  class InternalError < Error; end
  class LinkButtonNotPressed < Error; end
  class ParameterNotModifiableWhileOff < ParameterNotModifiable; end
  class TooManyGroups < Error; end
  class GroupTooFull < Error; end
  class UnknownError < Error; end

  # Status code to exception map
  RESPONSE_ERROR_MAP = {
      1 => HueHome::UnauthorizedUser,
      2 => HueHome::InvalidJSON,
      3 => HueHome::ResourceNotAvailable,
      4 => HueHome::MethodNotAvailable,
      5 => HueHome::MissingBody,
      6 => HueHome::ParameterNotAvailable,
      7 => HueHome::InvalidValueForParameter,
      8 => HueHome::ParameterNotModifiable,
    101 => HueHome::LinkButtonNotPressed,
    201 => HueHome::ParameterNotModifiableWhileOff,
    301 => HueHome::TooManyGroups,
    302 => HueHome::GroupTooFull,
    901 => HueHome::InternalError,
  }
end
