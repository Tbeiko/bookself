Fabricator(:user_book) do 
  user_id { Fabricate(:user).id }
  book_id { Fabricate(:book).id }
  status "read"
end