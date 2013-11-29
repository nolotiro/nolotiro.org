FactoryGirl.define do

  factory :ad do
    title "ordenador en Vallecas"
    body "pentium 9 con monitor de plasma de 90 pulgadas. pasar a recoger"
    type 1
    status 1
    woeid_code 766273
    ip "28.3.2.4"
    created_at "2013-11-01T10:41:00+01:00" 
    user
  end

end
