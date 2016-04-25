#
# Wraper around GeoPlanet::Place to find places related places that are towns
#
class YahooLocation
  attr_accessor :woeid

  def initialize(woeid)
    @woeid = woeid
  end

  def self.all
    @all ||= User.pluck(:woeid).uniq.map { |w| new(w) }
  end

  def place
    GeoPlanet::Place.new(woeid)
  rescue GeoPlanet::NotFound
    nil
  end

  def town?
    return false unless place

    place.placetype_code == 7
  end

  def descendants
    @descendants ||= GeoPlanet::Place.children_of(woeid)
  end

  def parent
    @parent ||= GeoPlanet::Place.parent_of(woeid)
  end

  def parent_town?
    parent.placetype_code == 7
  end

  def ancestor_town
    return unless parent

    return self.class.new(parent.woeid).ancestor_town unless parent_town?

    parent.woeid
  end

  def descendant_town
    return unless descendants.present?

    return inmediate_descendant_town if inmediate_descendant_town

    descendants.each do |d|
      dt = self.class.new(d.woeid).descendant_town
      return dt if dt
    end
  end

  def inmediate_descendant_town
    descendant = descendants.find { |d| d.placetype_code == 7 }
    return unless descendant

    descendant.woeid
  end
end
