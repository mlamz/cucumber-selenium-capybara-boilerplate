Given /^I visit Google$/ do
  visit "http://www.google.com"
end
When /^I search for something$/ do
  fill_in "gbqfq", :with => "a search term"
  click_button "gbqfb"
end
Then /^I should see some search results$/ do
  attempt_and_wait do
    search_results = all("li a.l")
    search_results.find_all{ | x| x.text.length > 0}.length.should == 10
  end
end