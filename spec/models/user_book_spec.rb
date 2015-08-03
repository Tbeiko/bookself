require "spec_helper"

describe UserBook do 
  it { should belong_to(:user) }
  it { should belong_to(:book) }
end 