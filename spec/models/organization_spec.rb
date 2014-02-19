require 'spec_helper'

describe Organization do
  it 'validates' do
    #create valid
    org = Organization.new(
        login:    'Jobs_Hunter',
        email:    'jobs01@mail.ru',
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
    org.valid?.should_not == nil
    #create invalid
    org = Organization.new(
        login:    'Jobs_Hunter_01',
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
    org.valid?.should_not == true

    #create invalid
    org = Organization.new(
        login:    'Jobs_Hunter_02',
        email:    'jobs02@mail.ru',
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
    org.valid?.should_not == true

    #create invalid
    org = Organization.new(
        login:    'Jobs_Hunter_03',
        email:    'jobs03@mail.ru',
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
    org.valid?.should_not == true

    #create invalid
    org = Organization.new(
        login:    'Jobs_Hunter_04',
        email:    'jobs04@mail.ru',
        password: 'jobspass',

        org_name:     'Apple',
        post_address: 'post address',
        jur_address:  'address',


        bik: '12345679',
        inn: '123456790',
        kpp: '12345689',
        ceo: 'Jobs'
    )
    org.valid?.should_not == true
  end

end
