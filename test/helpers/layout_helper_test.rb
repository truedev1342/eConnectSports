require 'test_helper'

class LayoutHelperTest < ActionView::TestCase
  test 'title stores the page title for the layout' do
    title('My Page')
    assert_equal 'My Page', view.content_for(:title)
  end

  test 'title escapes the given text' do
    title('<script>x</script>')
    assert_not_includes view.content_for(:title), '<script>'
  end

  test 'show_title? follows the second argument' do
    title('Shown')
    assert show_title?

    title('Hidden', false)
    assert_not show_title?
  end

  test 'show_title? is nil before a title is set' do
    assert_nil show_title?
  end
end
