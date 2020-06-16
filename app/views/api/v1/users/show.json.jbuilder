json.partial! 'user', locals: { user: @user }
if @user.employee?
    json.job do
        json.id @user.job.id
        json.name @user.job.name
        json.description @user.job.description
    end 
end