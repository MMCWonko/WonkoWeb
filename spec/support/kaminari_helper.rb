class StubbedPagination < Array
  attr_reader :total_count
  attr_reader :per_page
  attr_reader :current_page
  attr_reader :limit_value

  def total_pages
    total_count / per_page
  end

  def initialize(resources, total_count, per_page, current_page, limit_value)
    super(resources)
    @total_count = total_count
    @per_page = per_page
    @current_page = current_page
    @limit_value = limit_value
  end
end

def stub_pagination(resources, options = {})
  StubbedPagination.new(resources,
                        options[:total_count] || 10,
                        options[:per_page] || 25,
                        options[:current_page] || 1,
                        options[:limit_value] || nil)
end
