json.id user.id
json.name user.name
json.email user.email
json.phone user.phone
json.role user.role
json.status user.status
if user.employee?
    json.enterprise_id user.enterprise_id
end