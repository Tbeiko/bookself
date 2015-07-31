require 'rails_helper'

describe Identity do 
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should have_secure_password }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_length_of(:password).is_at_least(6) }
end