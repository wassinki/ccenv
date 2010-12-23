module WebratHelpers
  # performs an assert that expects false
  def assert_false(a)
    assert_equal(false, a)
  end
end

World(WebratHelpers)
