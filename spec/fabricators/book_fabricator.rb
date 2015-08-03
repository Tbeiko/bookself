Fabricator(:book) do 
  title            { Faker::Lorem.words(3).join(" ") }
  authors          { Faker::Name.name }
  cover_image_link { "http://ecx.images-amazon.com/images/I/51sAZ9rO5PL.jpg" }
  amazon_link      { "www." + Faker::Lorem.word + ".com"}
end