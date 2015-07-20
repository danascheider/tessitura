# A Fach is a singer's voice type. It has three attributes -- ++:type++, 
# ++:quality++, and ++:coloratura++ -- with the following restrictions:
#   * ++:type++ must be present
#   * ++:type++ must be one of 'soprano', 'mezzo-soprano', 'contralto',
#     'countertenor', 'tenor', 'baritone', and 'bass'
#   * ++:quality++ must be either 'lyric' or 'dramatic'
#   * ++:coloratura++ may be true or false
#
# Right now, I don't anticipate fachs being created dynamically. Instead,
# the following fachs will be added to the database as seed data:
#   * soprano/lyric/coloratura
#   * soprano/lyric
#   * soprano/dramatic/coloratura
#   * soprano/dramatic
#   * mezzo-soprano/lyric/coloratura
#   * mezzo-soprano/lyric
#   * mezzo-soprano/dramatic/coloratura
#   * mezzo-soprano/dramatic
#   * contralto/coloratura
#   * contralto
#   * countertenor
#   * tenor/lyric/coloratura
#   * tenor/lyric
#   * tenor/dramatic/coloratura
#   * tenor/dramatic
#   * baritone/lyric/coloratura
#   * baritone/lyric
#   * baritone/dramatic/coloratura 
#   * baritone/dramatic
#   * bass/lyric/coloratura
#   * bass/lyric
#   * bass/dramatic
#
# Additional fachs may be added depending on demand from users. There are
# also plans to create associations between fachs and pieces of music, to
# improve recommendations.

class Fach < Sequel::Model(:fachs)
  one_to_many :users

  TYPE_OPTIONS = ['soprano', 'mezzo-soprano', 'contralto', 'countertenor', 'tenor', 'baritone', 'bass']
  QUALITY_OPTIONS = ['lyric', 'dramatic']

  class << self

    # The ++::infer++ method sets any undefined attributes to nil to identify
    # the single requested fach. For example, given two fachs a and b such that
    #     a = Fach.new(type: 'baritone', quality: 'lyric')
    #     b = Fach.new(type: 'baritone', quality: 'lyric', coloratura: true),
    # the ++Sequel::Model#find++ method will return both of them when called with
    # ++{type: 'baritone', quality: 'lyric'}++:
    #     Fach.find(type: 'baritone', quality: 'lyric')      # => [a, b]
    #     Fach.infer(type: 'baritone', quality: 'lyric')     # => a

    def infer attrs
      attrs[:quality] ||= nil
      attrs[:coloratura] ||= false
      Fach.find(attrs)
    end
  end

  def to_hash
    {
      id: id,
      type: type,
      quality: quality,
      coloratura: coloratura
    }.reject {|k,v| !v }
  end

  alias_method :to_h, :to_hash

  def to_json(opts = nil)
    to_h.to_json
  end

  def validate
    super
    validates_includes TYPE_OPTIONS, :type
    validates_includes QUALITY_OPTIONS, :quality if quality
  end
end