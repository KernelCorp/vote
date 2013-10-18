require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test 'validates' do
    #create valid
    org = Organization.new(
        email:    'jobs@mail.ru',
        password: 'jobspass',

        org_name:     'Apple',
        post_address: 'post address',
        jur_address:  'address',

        rc:  '12345678901234567890',
        kc:  '12345678901234567890',
        bik: '123456789',
        inn: '1234567890',
        kpp: '123456789',
        ceo: 'Jobs'
    )
    assert org.valid?

    #create invalid
    org = Organization.new(
        email:    'jobs@mail.ru',
        password: 'jobspass',

        org_name:     'Apple',
        post_address: 'post address',
        jur_address:  'address',

        rc:  '1234567890123456789',
        kc:  '1234567890123456789',
        bik: '12345679',
        inn: '123456790',
        kpp: '12345689',
        ceo: 'Jobs'
    )
    assert !org.valid?

    #create invalid
    org = Organization.new(
        email:    'jobs@mail.ru',
        password: 'jobspass',

        org_name:     'Apple',
        post_address: 'post address',
        jur_address:  'address',

        rc:  '1234567890123456789',
        kc:  '1234567890123456789',
        bik: '12345679',
        inn: '12345670',
        kpp: '12345689',
        ceo: 'Jobs'
    )
    assert !org.valid?

    #create invalid
    org = Organization.new(
        email:    'jobs@mail.ru',
        password: 'jobspass',

        org_name:     'Apple',
        post_address: 'post address',
        jur_address:  'address',

        rc:  'q2345678901234567890',
        kc:  'q2345678901234567890',
        bik: '1e345679',
        inn: '123456790',
        kpp: '12345689',
        ceo: 'Jobs'
    )
    assert !org.valid?

    #create invalid
    org = Organization.new(
        email:    'jobs@mail.ru',
        password: 'jobspass',

        org_name:     'Apple',
        post_address: 'post address',
        jur_address:  'address',


        bik: '12345679',
        inn: '123456790',
        kpp: '12345689',
        ceo: 'Jobs'
    )
    assert !org.valid?
  end

end
