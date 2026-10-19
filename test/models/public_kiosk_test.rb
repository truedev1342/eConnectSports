require 'test_helper'

class PublicKioskTest < ActiveSupport::TestCase
  test 'belongs to a team' do
    assert_equal teams(:one), public_kiosks(:one).team
  end

  test 'is reachable from its team' do
    assert_equal public_kiosks(:one), teams(:one).public_kiosk
  end

  test 'a team is required' do
    kiosk = PublicKiosk.new
    assert_not kiosk.valid?
    assert_includes kiosk.errors.attribute_names, :team
  end

  test 'stores a description' do
    assert_equal 'First team kiosk', public_kiosks(:one).description
  end

  test 'mounts logo and background uploaders' do
    kiosk = public_kiosks(:one)
    assert_respond_to kiosk, :logo
    assert_respond_to kiosk, :background
    assert_kind_of LogoUploader, kiosk.logo
    assert_kind_of BackgroundUploader, kiosk.background
  end
end
