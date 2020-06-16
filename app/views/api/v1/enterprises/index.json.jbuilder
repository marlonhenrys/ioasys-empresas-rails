json.total_pages @enterprises.total_pages
json.total_count @enterprises.total_count
json.current_page @enterprises.current_page
json.enterprises @enterprises.each do |enterprise|
    json.id enterprise.id
    json.name enterprise.name
    json.description enterprise.description
end