require 'test_helper'

class TextPageTest < ActiveSupport::TestCase
  test 'get related pages' do
    page = text_pages :for_org
    actual = page.get_related_pages
    assert_include actual, text_pages(:for_org_2)
    assert_include actual, text_pages(:for_all)
    assert_not_include actual, page
    assert_not_include actual, text_pages(:for_participants)

    page = text_pages :for_participants
    actual = page.get_related_pages
    assert_include actual, text_pages(:for_participants_2)
    assert_include actual, text_pages(:for_all)
    assert_not_include actual, page
    assert_not_include actual, text_pages(:for_org)
  end
end
