json.total_pages @users.total_pages
json.total_count @users.total_count
json.current_page @users.current_page
json.users @users.each do |user|
    json.id user.id
    json.name user.name
    json.email user.email
    json.role user.role
    if user.employee?
        json.enterprise_id user.enterprise_id
    end
end